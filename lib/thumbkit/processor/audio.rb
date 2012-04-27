require 'waveform'

# TODO: Take and use options
class Thumbkit::Processor::Audio < Thumbkit::Processor

  def write
    options = { force: true, method: :rms, width: 200, height: 200 }
    Waveform.new(path).generate(outfile, options)

    outfile
  end

end
