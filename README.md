# Thumbkit

NOTE: None of this is implemented yet!

Thumbkit makes thumbnails from a variety of media types.
Thumbkit is designed to work with carrierwave but does not require it.

Sort term planned types: Audio, Plain Text (and probably HTML), Image.

Longer term planned types: Video, PDF.

## Installation

Add this line to your application's Gemfile:

    gem 'thumbkit'
    gem 'mini_magick' # For text or image thumbnails
    gem 'waveform' # For audio thumbnails

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thumbkit

## Usage

Thumbkit takes a path to a file, and saves a thumbnail for that file regardless
of type. Certain types require different gems, but none are dependencies so
you'll have to install them yourself.

All settings can be set globally.

```ruby
  Thumbkit.defaults = {
    width: 60, height: 60,
    colors: { foreground: '#333', background: '#eee' },
    font: { family: 'Helvetica', pointsize: '14' },
  }
```

```ruby
  Thumbkit.new('path/to/image.jpg').write_thumbnail
```

Will write a 60x60 cropped image to `path/to/image.jpg`.

```ruby
  text = Thumbkit.new('path/to/text_file.txt')

  text.write_thumbnail(nil, {
    width: 200, height: 200,
    colors: { foreground: '#663854' },
    font: { pointsize: '18' },
  })

```

Will write a 200x200 cropped image to `path/to/text_file.png`.

```ruby
  audio = Thumbkit.new('path/to/audio.mp3')
  audio.write_thumbnail('path/to/ouput.png', {
    colors: { foreground: '#fff', background: '#000' },
  })
```

Will write a 60x60 cropped image to `path/to/output.png`.

NOTE: When the output filename is inferred, the filetype will also be inferred
depending on the input type. In general, image files thumbnails should be the
same type as their original. Video thumbnails should be jpg. Text and audio
thumbnails should be png.

### CarrierWave usage

```ruby
  class MyUploader < CarrierWave::Uploader::Base
    include CarrierWave::Thumbkit

    version :thumbnail do
      process :thumbkit => [200, 200, { colors: { foreground: '#ccc' } }]
    end
  end
```

## Other plans

* Accept a StringIO instead of a pathname
* Maybe use filemagic if available

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
