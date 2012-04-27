require "thumbkit/version"

class Thumbkit
  autoload :Processor, 'thumbkit/processor'
  autoload :Options, 'thumbkit/options'

  attr_accessor :path, :filename, :type

  def self.defaults
    @defaults ||= Thumbkit::Options.new({
      colors: {},
      font: {},
    })
  end

  def initialize(path)
    @path = File.expand_path(path)
    @filename = File.basename(@path)
    @type = File.extname(filename)[1..-1]
  end

  def processor
    @processor ||= Thumbkit::Processor.processor_for(type).new(path)
  end
end
