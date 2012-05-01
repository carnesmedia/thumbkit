class Thumbkit::Processor
  autoload :Text, 'thumbkit/processor/text'
  autoload :Audio, 'thumbkit/processor/audio'
  autoload :Image, 'thumbkit/processor/image'

  def self.processors
    @processors ||= {
      'png' => 'Image',
      'jpg' => 'Image',
      'txt' => 'Text',
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
    @outfile = outfile || auto_outfile
    @options = Thumbkit.defaults + options
  end

  def auto_outfile
    @path
  end

  def write
    raise NotImplementedError
  end

end
