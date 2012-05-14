# Thumbkit

Thumbkit makes thumbnails from a variety of media types.
Thumbkit is designed to work with carrierwave but does not require it.

> it's like quicklook for carrierwave :)
>
> -- <cite>[Emmanuel Gomez][1]</cite>

 [1]:https://github.com/emmanuel

## Synopsis

```ruby
Thumbkit.new('path/to/audio.mp3').write_thumbnail # => 'path/to/audio.png'
Thumbkit.new('path/to/text.txt').write_thumbnail  # => 'path/to/text.png'
Thumbkit.new('path/to/image.jpg').write_thumbnail # => 'path/to/image.jpg'
```

See [Usage](#usage) below for more examples

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thumbkit'
gem 'mini_magick' # For text or image thumbnails
gem 'waveform' # For audio thumbnails
gem 'oily_png' # Optional, for presumably faster audio thumbnails
```

And then execute:

```shell
$ bundle
```

Please see [Requirements](#requirements) for more information about each
thumbnail type.


## Requirements

### Image thumbnails

Thumbkit uses [MiniMagick](https://github.com/probablycorey/mini_magick) to
resize and crop images.

If you plan to support thumbnails raw files, imagemagick delegate raw processing
to [ufraw](http://ufraw.sourceforge.net/).

On OS X:

    $ brew install ufraw # Optional, for processing cr2, raw, etc
    $ brew install imagemagick
    $ gem install mini_magick

### Text thumbnails

Thumbkit uses [MiniMagick](https://github.com/probablycorey/mini_magick) to
render text files.

On OS X:

    $ brew install imagemagick
    $ gem install mini_magick

### HTML thumbnails

HTML thumbnails are not yet supported, but the plan is to use phantomjs to
render html files.

### Audio thumbnails

Thumbkit uses the [waveform](https://github.com/benalavi/waveform) gem to render
audio files. [waveform](https://github.com/benalavi/waveform) depends on
libsndfile. **ffmpeg** is required in order to generate thumbnails from anything
other than .wav files.

See https://github.com/benalavi/waveform for more on requirements.

    $ brew install ffmpeg # Optional for mp3
    $ brew install libsndfile


NOTE: As of 0.0.3 waveform fails on mono files
([benalavi/waveform#4](https://github.com/benalavi/waveform/issues/4),
[benalavi/waveform#5](https://github.com/benalavi/waveform/issues/5)).
I've forked and fixed the issue (see
[benalavi/waveform#6](https://github.com/benalavi/waveform/pull/6)). Until my
fix gets merged in you can use https://github.com/amiel/waveform/tree/thumbkit.
Like so:


```ruby
gem 'thumbkit'
gem 'waveform', git: 'https://github.com/amiel/waveform', branch: 'thumbkit'
gem 'oily_png' # Optional, for presumably faster audio thumbnails
```

## Usage

Thumbkit takes a path to a file, and saves a thumbnail for that file regardless
of type. Certain types require different gems, but none are dependencies so
you'll have to install them yourself.

### Image thumbnails

```ruby
  Thumbkit.new('path/to/image.jpg').write_thumbnail # => 'path/to/image.jpg'
```

Will write a 200x200 cropped image to `path/to/image.jpg`.

The format of the output file will depend on the extension of the output path
and defaults to the same as the input file.

### Text thumbnails

```ruby
  text = Thumbkit.new('path/to/text_file.txt')

  text.write_thumbnail(nil, {
    width: 160, height: 160,
    colors: { foreground: '#663854' },
    font: { pointsize: '18' },
  }) # => 'path/to/text_file.png'
```

Will write a 160x160 cropped image to `path/to/text_file.png`.

The format of output will depend on the extension of the output path provided
but defaults to .png.

#### RTL support

```ruby
  text = Thumbkit.new('path/to/text_file.txt')
  text.write_thumbnail(nil, font: { direction: 'right-to-left' }) # Force RTL
```

`direction` options:

* `nil`: don't specify the option to imagemagick (OS default)
* `:auto`: try to detect. Currently, this switches to `'right-to-left'` if there
  are *any* RTL characters in the input. This is the default.
* `'right-to-left'`, `'left-to-right'`: force LTR or RTL

### Audio thumbnails

```ruby
  audio = Thumbkit.new('path/to/audio.mp3')
  audio.write_thumbnail('path/to/ouput.png', {
    colors: { foreground: '#ffffff', background: '#000000' },
  }) # => 'path/to/output.png'
```

Will write a 200x200 cropped image to `path/to/output.png`.

Note that while imagemagick supports most color specification formats, waveform
only takes 6 digit hex values. However, there is one special case for the symbol
:transparent.

Audio thumbnails only support PNG output. A png file will be created regardless
of the extension of the output file provided.

### Composite thumbnails

```ruby
  composite = Thumbkit.new(['path/to/audio.mp3', 'path/to/text_file.txt'])
  composite.write_thumbnail('path/to/collection.png')
```

### CarrierWave usage

```ruby
  class MyUploader < CarrierWave::Uploader::Base
    include Thumbkit::Adapters::CarrierWave

    version :thumbnail do
      # See Configuration below for more about options.
      process thumbkit: [200, 200, { colors: { foreground: '#cccccc' } }]

      # This tells CarrierWave where the version file can be found since
      # thumbkit can write a to a file with a different extension than the
      # original.
      #
      # See https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Customize-your-version-file-names
      # for more about
      def full_filename(for_file = model.file.file)
        [version_name, thumbkit_filename(for_file)].join('_')
      end
    end
  end
```

## Configuration

All settings can be set globally. These are the defaults:

```ruby
  Thumbkit.defaults = {
    width: 200, height: 200,
    gravity: 'Center',
    colors: { foreground: '#888888', background: '#eeeeee' },
    font: {
      family: 'Arial-Regular',
      pointsize: '18',
      direction: :auto,
    },
  }
```

Setting `Thumbkit.defaults=` will deep merge. So setting one option is possible
with:

```ruby
  Thumbkit.defaults = { colors: { foreground: '#FF69B4' } } # HOT PINK
```

#### Font options

The list of fonts available to imagemagick can be found with
`identify -list Font`

#### Gravity Options

A list of gravity options can be found with `identify -list Gravity`

See http://www.imagemagick.org/script/command-line-options.php#gravity for more
information.

#### Processors

Built-in processors can be found in `lib/thumbkit/processor`.

Adding a processor mapping:

```ruby
Thumbkit.processors['jpeg'] = 'Image'
```

##### Custom processors

```ruby
class Thumbkit::Processor::Doc < Thumbkit::Processor
  def write
    # use `path` to generate `outfile`

    # always return the generated filename
    outfile
  end
end

Thumbkit.processors['doc'] = 'Doc'
```

## Other plans

* Optionally accept a StringIO instead of a pathname
* Maybe use filemagic/mime-type if available
* Paperclip processor
* Processors:
  * HTML
  * PDF
  * Video

## Known Issues

* If the output file has an uppercase extension, image processing may break.
  This will not be an issue if you are not supplying the output filename as
  `Thumbkit::Image` will always pick a lowercase extension by default.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run the test suite to make sure all tests pass before you start (`guard`)
4. Make your changes
5. Run the test suite again to make sure you didn't break anything existing (`guard`)
6. Commit your changes (`git commit -am 'Added some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

## Testing

Tests run in guard. If you don't like guard, a pull request on `Rakefile` would
be welcome.

Output files are placed in `spec/tmp` which is created automatically before each
test run and deleted automatically afterward unless `spec/tmp/.keep` exists. If
you would like to inspect the generated output files, create a file at
`spec/tmp/.keep`:

    $ mkdir spec/tmp; touch spec/tmp/.keep

Many of the tests just verify that an image was created of the right type and
size, but do not actually verify that they have the correct content so it is
good to inspect the generated files.
