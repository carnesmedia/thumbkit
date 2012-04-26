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

```ruby
  image = Thumbkit.new('path/to/image.jpg')
  image.thumbnail(60, 60)
```

`path/to/image.jpg` will now be a 60x60 cropped image

```ruby
  # TODO: should we accept strings? or just a path to a file
  text = Thumbkit.new('path/to/text_file.txt',
    colors: { foreground: '#fff', background: '#000' },
    font: { family: 'Times New Roman', size: '10pt' }
  )
  text.thumbnail(60, 60)
```

`path/to/text_file.png` will now be a 60x60 image

```ruby
  audio = Thumbkit.new('path/to/audio.mp3',
    output: 'path/to/ouput.png',
    colors: { foreground: '#fff', background: '#000' }
  )
  audio.thumbnail(60, 60)
```

`path/to/output.png` will now be a 60x60 image

NOTE: When the output filename is inferred, the filetype will also be inferred
depending on the input type. In general, image files thumbnails should be the
same type as their original. Video thumbnails should be jpg. Text and audio
thumbnails should be png.

### CarrierWave usage

```ruby
  class MyUploader < CarrierWave::Uploader::Base
    include CarrierWave::Thumbkit

    version :thumbnail do
      process :thumbkit
    end
  end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
