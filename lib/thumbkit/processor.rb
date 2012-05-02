class Thumbkit::Processor
  autoload :Text, 'thumbkit/processor/text'
  autoload :Audio, 'thumbkit/processor/audio'
  autoload :Image, 'thumbkit/processor/image'
  autoload :Collection, 'thumbkit/processor/collection'

  def self.processors
    @processors ||= {
      'png' => 'Image',
      'jpg' => 'Image',
      'gif' => 'Image',
      'txt' => 'Text',
      'md'  => 'Text',
      'mp3' => 'Audio',
      'wav' => 'Audio',
      'm4a' => 'Audio',
    }
  end

  def self.processor_for(extension)
    if (class_name = self.processors[extension])
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
    @options = Thumbkit.defaults + options
  end

  def determine_outfile
    raise NotImplementedError, 'Cannot determine an output file'
  end

  def write
    raise NotImplementedError
  end

end
