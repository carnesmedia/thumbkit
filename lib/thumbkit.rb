require "thumbkit/version"

class Thumbkit
  autoload :Processor, 'thumbkit/processor'
  autoload :Options, 'thumbkit/options'
  autoload :Adapters, 'thumbkit/adapters'

  def self.defaults
    @defaults ||= Thumbkit::Options.new({
      width: 200,
      height: 200,
      # Whether or not we crop to fill the entire thumbnail size.
      # Only affects images.
      crop: true,
      # Run `identify -list Gravity` for a list of available options
      gravity: 'Center',
      colors: {
        # Colors must be 6-digit hex
        background: '#eeeeee',
        foreground: '#888888',
      },
      font: {
        # Run `identify -list Font` for available font options
        family: 'Arial-Regular',
        size: '18', # In points
        direction: :auto, # nil, :auto, 'right-to-left', or 'left-to-right'
      },
    })
  end

  def self.defaults=(options)
    @defaults = defaults + options
  end

  def self.processors
    Thumbkit::Processor.processors
  end

  attr_accessor :path, :filename, :type

  def initialize(path)
    if Array === path
      @processor = Thumbkit::Processor::Collection
      @path = path.map { |p| File.expand_path(p) }
    else
      @path = File.expand_path(path)
      @filename = File.basename(@path)
      @type = File.extname(@filename)[1..-1]

      if ! self.processor
        raise ArgumentError, "No processor defined for '#{ @type }'"
      end
    end
  end

  def processor
    @processor ||= Thumbkit::Processor.processor_for(type)
  end

  def processor_instance(outfile = nil, options = {})
    processor.new(path, outfile, options)
  end

  def write_thumbnail(outfile = nil, options = {})
    processor_instance(outfile, options).write
  end
end
