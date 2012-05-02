class Thumbkit::Processor::Collection < Thumbkit::Processor

  alias_method :paths, :path

  def determine_outfile
    raise ArgumentError, 'Thumbkit: At output file must be provided for collections'
  end

  def write
    sources = generate_each
    command = build_montage_command(sources)
    run(command)

    command = build_resize_command(outfile)
    run(command)

    outfile
  end

  def collection
    self.paths.map do |path|
      Thumbkit.new(path)
    end
  end

  private

  def generate_each
    collection.map do |thumbkit|
      outdir = File.dirname(outfile)
      output_filename = File.basename(thumbkit.processor_instance.outfile)

      thumbkit.write_thumbnail(File.join(outdir, output_filename), options)
    end
  end


  # montage arabic.png greek.png png_file.png -geometry '1x1<+0+0' collection.png; open collection.png
  def build_montage_command(sources)
    MiniMagick::CommandBuilder.new('montage').tap do |montage|
      sources.each do |source|
        montage << source
      end

      montage.geometry '1x1<+0+0'

      montage.background options[:colors][:background]
      montage.gravity(options[:gravity] || 'Center')

      montage << outfile
    end
  end

  def build_resize_command(outfile)
    MiniMagick::CommandBuilder.new('mogrify').tap do |resize|
      resize.resize "#{ options[:width] }x#{ options[:height] }>"
      resize.background options[:colors][:background]
      resize.extent "#{ options[:width] }x#{ options[:height] }"
      resize << outfile
    end
  end

  # Mostly copied from MiniMagick
  def run(command_builder)
    command = command_builder.command

    sub = Subexec.run(command, timeout: MiniMagick.timeout)

    if sub.exitstatus != 0

      # Raise the appropriate error
      if sub.output =~ /no decode delegate/i || sub.output =~ /did not return an image/i
        raise MiniMagick::Invalid, sub.output
      else
        # TODO: should we do something different if the command times out ...?
        # its definitely better for logging.. otherwise we dont really know
        raise MiniMagick::Error, "Command (#{command.inspect.gsub("\\", "")}) failed: #{{:status_code => sub.exitstatus, :output => sub.output}.inspect}"
      end
    else
      sub.output
    end
  end

end
