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
end
