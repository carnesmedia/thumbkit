require 'waveform'

# TODO: Take and use options
class Thumbkit::Processor::Audio < Thumbkit::Processor

  def auto_outfile
    self.class.force_extension(path, 'png')
  end

  def write
    Waveform.new(path).generate(outfile, build_options)

    outfile
  end

  private

  def build_options
    {
      force: true,
      method: :rms, # Hard-coded for now.
      width: options[:width],
      height: options[:height],
      color: options[:colors][:foreground],
      background_color: options[:colors][:background],
    }
  end

end
