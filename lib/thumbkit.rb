require "thumbkit/version"

class Thumbkit
  autoload :Processor, 'thumbkit/processor'
  autoload :Options, 'thumbkit/options'

  attr_accessor :path, :filename, :type

  def self.defaults
    @defaults ||= Thumbkit::Options.new({
      width: 200,
      height: 200,
      colors: {
        background: '#eeeeee',
        foreground: '#888888',
      },
      font: {
        family: 'Arial-Regular', # Try `identify -list Font`
        size: '18', # In points
        direction: :auto, # nil, :auto, 'right-to-left', or 'left-to-right'
      },
    })
  end

  def initialize(path)
    @path = File.expand_path(path)
    @filename = File.basename(@path)
    @type = File.extname(filename)[1..-1]
  end

  def processor
    @processor ||= Thumbkit::Processor.processor_for(type)
  end

  def write_thumbnail(outfile = nil, options = {})
    processor.new(path, outfile, options).write
  end
end
