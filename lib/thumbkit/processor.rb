class Thumbkit::Processor
  autoload :Text,       'thumbkit/processor/text'
  autoload :Audio,      'thumbkit/processor/audio'
  autoload :Image,      'thumbkit/processor/image'
  autoload :Collection, 'thumbkit/processor/collection'

  def self.processors
    @processors ||= {
      'bmp'   => 'Image',
      'cr2'   => 'Image', # Canon RAW
      'crw'   => 'Image', # Canon RAW
      'dng'   => 'Image', # Adobe Digital Negative
      'gif'   => 'Image',
      'jpg'   => 'Image',
      'jpeg'  => 'Image',
      'nef'   => 'Image', # Nikon RAW
      'nrw'   => 'Image', # Nikon RAW
      'png'   => 'Image',
      'psd'   => 'Image',
      'raw'   => 'Image',
      'sr2'   => 'Image', # Sony RAW
      'srf'   => 'Image', # Sony RAW
      'tif'   => 'Image',
      'tiff'  => 'Image',
      'yuv'   => 'Image',
      'txt'   => 'Text',
      'md'    => 'Text',
      'rb'    => 'Text',
      'mp3'   => 'Audio',
      'wav'   => 'Audio',
      'm4a'   => 'Audio',
    }
  end

  def self.processor_for(extension)
    if (class_name = self.processors[extension.downcase])
      self.const_get(class_name)
    end
  end


  def self.force_extension(filename, extension)
    dir, fname = File.split(filename)
    File.join(dir, "#{ File.basename(fname, '.*') }.#{ extension }")
  end

  attr_accessor :path, :outfile, :options
  def initialize(path, outfile, options)
    @path = path
    @outfile = outfile || determine_outfile
    @options = default_options + options + options.fetch(processor_name, {})
  end

  def processor_name
    self.class.name.split('::').last.to_sym
  end

  def default_options
    Thumbkit.defaults + Thumbkit.defaults.fetch(processor_name, {})
  end

  def determine_outfile
    raise NotImplementedError, 'Cannot determine an output file'
  end

  def write
    raise NotImplementedError
  end

end
