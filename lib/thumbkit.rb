require "thumbkit/version"

class Thumbkit
  autoload :Processors, 'thumbkit/processors'
  autoload :Defaults, 'thumbkit/defaults'

  attr_accessor :path, :filename, :type

  def self.defaults
    @defaults ||= Thumbkit::Defaults.new({
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
    @processor ||= Thumbkit::Processors.processor_for(type).new(path)
  end
end
