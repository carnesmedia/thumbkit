require 'mini_magick'

class Thumbkit::Processor::Image < Thumbkit::Processor

  def auto_outfile
    @path
  end

  def write
    outfile
  end

end
