require 'mini_magick'

class Thumbkit::Processor::Image < Thumbkit::Processor

  def determine_outfile
    @path
  end

  def write
    resize_to_fill

    outfile
  end



  private

  def type
    File.extname(outfile)[1..-1]
  end


  # Copied and adjusted from CarrierWave
  def resize_to_fill
    image = ::MiniMagick::Image.open(path)

    cols, rows = image[:dimensions]
    image.format type
    image.combine_options do |cmd|
      if options[:width] != cols || options[:height] != rows
        scale = [options[:width]/cols.to_f, options[:height]/rows.to_f].max
        cols = (scale * (cols + 0.5)).round
        rows = (scale * (rows + 0.5)).round
        cmd.resize "#{ cols }x#{ rows }"
      end
      cmd.gravity options[:gravity].to_s if options[:gravity]
      cmd.background options[:colors][:background].to_s

      if cols != options[:width] || rows != options[:height]
        cmd.extent "#{ options[:width] }x#{ options[:height] }"
      end
    end

    image.write(outfile)
  end
end
