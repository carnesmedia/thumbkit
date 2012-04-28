require 'mini_magick'

# TODO: Take and use options
class Thumbkit::Processor::Text < Thumbkit::Processor

  def auto_outfile
    # raise NotImplementedError
  end

  def write
    command = build_command
    run(command)

    outfile
  end

  private


  def command_builder
    MiniMagick::CommandBuilder.new('mogrify')
  end

  # Example generated command
  # mogrify -density "288" -background "#ccc" -fill "#333" -pointsize "18" -antialias -font "Helvetica" -format png -trim -resize "%25" +repage -crop "200x200+10+10" +repage -write test.png test.txt
  def build_command
    command_builder.tap do |mogrify|
      mogrify.density((72 * 4).to_s)
      mogrify.background options[:colors][:background].to_s
      mogrify.fill options[:colors][:foreground].to_s
      mogrify.pointsize options[:font][:size]
      mogrify.antialias
      mogrify.font options[:font][:family]
      mogrify << '-format png'
      mogrify.trim
      mogrify.resize '25%'
      mogrify << '+repage'
      # TODO: Handle the offset better
      mogrify.crop "#{ options[:width] }x#{ options[:height] }+10+10"
      mogrify << '+repage'
      mogrify.write outfile
      mogrify << path
    end
  end

  # Mostly copied from MiniMagick
  def run(command_builder)
    command = command_builder.command

    sub = Subexec.run(command, :timeout => MiniMagick.timeout)

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
