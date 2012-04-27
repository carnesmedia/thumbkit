class Thumbkit::Processor
  autoload :Text, 'thumbkit/processor/text'

  def self.processors
    @processors ||= {
      'txt' => 'Text',
    }
  end

  def self.processor_for(extension)
    if (class_name = self.processors[extension])
      self.const_get(class_name)
    end
  end


  attr_accessor :path, :outfile, :option
  def initialize(path, outfile, options)
    @path = path
    @outfile = outfile || auto_outfile
    @options = options
  end

  def auto_outfile
    @path
  end

  def write
    raise NotImplementedError
  end

end
