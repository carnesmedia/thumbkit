require 'mini_magick'

class Thumbkit::Processor::Image < Thumbkit::Processor

  def determine_outfile
    ext = File.extname(@path)[1..-1].downcase
    self.class.force_extension(path, format_conversions[ext] || ext)
  end

  def write
    options[:crop] ? resize_to_fill : resize_to_fit

    outfile
  end

  # Public to allow customization
  def format_conversions
    @_format_conversions ||= {
      'cr2'   => 'jpg', # Canon RAW
      'crw'   => 'jpg', # Canon RAW
      'dng'   => 'jpg', # Adobe Digital Negative
      'nef'   => 'jpg', # Nikon RAW
      'nrw'   => 'jpg', # Nikon RAW
      'psd'   => 'jpg',
      'raw'   => 'jpg',
      'sr2'   => 'jpg', # Sony RAW
      'srf'   => 'jpg', # Sony RAW
      'cr2'   => 'jpg',
      'raw'   => 'jpg',
    }
  end

  private

  def type
    File.extname(outfile)[1..-1]
  end

  # Copied and adjusted from CarrierWave

  def resize_to_fit
    image = ::MiniMagick::Image.open(path)
    image.format type
    image.resize "#{options[:width]}x#{options[:height]}"
    image.write(outfile)
  end

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
