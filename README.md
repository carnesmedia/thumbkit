# Thumbkit

NOTE: Not all of this is implemented yet. 0.0.2 will mark the release of this
  initial spec.

Thumbkit makes thumbnails from a variety of media types.
Thumbkit is designed to work with carrierwave but does not require it.

Sort term planned types: Audio, Plain Text (and probably HTML), Image.

Longer term planned types: Video, PDF, HTML.

## Synopsis

```ruby
Thumbkit.new('path/to/audio.mp3').write_thumbnail # => 'path/to/audio.png'
Thumbkit.new('path/to/text.txt').write_thumbnail  # => 'path/to/text.png'
Thumbkit.new('path/to/image.jpg').write_thumbnail # => 'path/to/image.jpg'
```

See [Usage](#usage) below for more examples

## Installation

Add this line to your application's Gemfile:

    gem 'thumbkit'
    gem 'mini_magick' # For text or image thumbnails
    gem 'waveform' # For audio thumbnails

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thumbkit

## Requirements

### Image thumbnails

Thumbkit uses MiniMagick to resize and crop images.

### Text thumbnails

Thumbkit uses MiniMagick to render text files, and therefore depends on the
[minimagick](https://github.com/probablycorey/mini_magick) gem and imagemagick.

Fonts:

The list of fonts available to imagemagick can be found with `identify -list Font`

### HTML thumbnails

HTML thumbnails are not yet supported, but the plan is to use phantomjs to
render html files.

### Audio thumbnails

Thumbkit uses the [waveform](https://github.com/benalavi/waveform) gem to render
audio files. [waveform](https://github.com/benalavi/waveform) depends on
libsndfile. **ffmpeg** is required in order to generate thumbnails from anything
other than .wav files.

See https://github.com/benalavi/waveform for more on requirements.

NOTE: As of 0.0.3 waveform fails on mono files (benalavi/waveform#4,
benalavi/waveform#5. I've forked and fixed (see benalavi/waveform#6). Until my
fix gets merged in you can use https://github.com/amiel/waveform/tree/thumbkit.
Like so:

```ruby
gem 'thumbkit'
gem 'waveform', git: 'https://github.com/amiel/waveform', branch: 'thumbkit'
gem 'oily_png' # Optional. For presumably faster png cration with waveform
```

## Usage

Thumbkit takes a path to a file, and saves a thumbnail for that file regardless
of type. Certain types require different gems, but none are dependencies so
you'll have to install them yourself.

All settings can be set globally.

```ruby
  Thumbkit.defaults = {
    width: 60, height: 60,
    colors: { foreground: '#333333', background: '#eeeeee' },
    font: { family: 'Helvetica', pointsize: '14' },
  }
```

### Image thumbnails

```ruby
  Thumbkit.new('path/to/image.jpg').write_thumbnail # => 'path/to/image.jpg'
```

Will write a 60x60 cropped image to `path/to/image.jpg`.


NOTE: When the output filename is inferred, the filetype will also be inferred
depending on the input type. In general, image files thumbnails should be the
same type as their original. Video thumbnails should be jpg. Text and audio
thumbnails should be png.

### Text thumbnails

```ruby
  text = Thumbkit.new('path/to/text_file.txt')

  text.write_thumbnail(nil, {
    width: 200, height: 200,
    colors: { foreground: '#663854' },
    font: { pointsize: '18' },
  }) # => 'path/to/text_file.png'
```

Will write a 200x200 cropped image to `path/to/text_file.png`.

#### RTL support

```ruby
  text = Thumbkit.new('path/to/text_file.txt')
  text.write_thumbnail(nil, font: { direction: :auto }) # Default, detect automatically
  text.write_thumbnail(nil, font: { direction: 'right-to-left' }) # Force RTL
```

`direction` options:

* `nil`: don't specify the option to imagemagick (OS default)
* `:auto`: try to detect. Currently, this switches to `'right-to-left'` if there
  are *any* RTL characters in the input.
* `'right-to-left'`, `'left-to-right'`: force LTR or RTL

### Audio thumbnails

```ruby
  audio = Thumbkit.new('path/to/audio.mp3')
  audio.write_thumbnail('path/to/ouput.png', {
    colors: { foreground: '#ffffff', background: '#000000' },
  }) # => 'path/to/output.png'
```

Will write a 60x60 cropped image to `path/to/output.png`.

Note that while imagemagick supports most color specification formats, waveform
only takes 6 digit hex values. However, there is one special case for the symbol
:transparent.

Audio thumbnails only support PNG output.

### Composite thumbnails

```ruby
  composite = Thumbkit.new(['path/to/audio.mp3', 'path/to/text_file.txt'])
  composite.write_thumbnail('path/to/collection.png')
```


### CarrierWave usage

```ruby
  class MyUploader < CarrierWave::Uploader::Base
    include CarrierWave::Thumbkit

    version :thumbnail do
      process :thumbkit => [200, 200, { colors: { foreground: '#cccccc' } }]
    end
  end
```

## Other plans

* Accept a StringIO instead of a pathname
* Maybe use filemagic if available
* Processors:
  * HTML
  * PDF
  * Video

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
