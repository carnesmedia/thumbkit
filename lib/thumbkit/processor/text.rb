require 'mini_magick'

# NOTES: For now, use reverse markdown for html
#   https://github.com/xijo/reverse_markdown
#   https://github.com/cousine/downmark_it
class Thumbkit::Processor::Text < Thumbkit::Processor

  def auto_outfile
    self.class.force_extension(path, 'png')
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

  # Regexes copies from www.frequency-decoder.com/demo/detect-text-direction/
  # and https://github.com/geeksoflondon/grid4rails/issues/120
  #
  # Currently, this detects the direction by checking if *any* character in the
  # input is an RTL character.
  # TODO: Maybe check for a percentage of RTL characters?
  def direction
    # For future reference
    # Hebrew - U+05D0 to U+05EA, U+05F0 to U+05F2, U+05BE, U+05C0, U+05C3, U+05F3, U+05F4, U+05B0 to U+05C4, U+0591 to U+05AF.
    # Arabic - U+0600 to U+06FF, U+0750 to U+077F, U+FB50 to U+FDFF, U+FE70 to U+FEFF, U+10E60 to U+10E7F.
    # ltrChars            = 'A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02B8\u0300-\u0590\u0800-\u1FFF'+'\u2C00-\uFB1C\uFDFE-\uFE6F\uFEFD-\uFFFF',
    # rtlChars            = '\u0591-\u07FF\uFB1D-\uFDFD\uFE70-\uFEFC',

    dir = options[:font][:direction]
    if dir == :auto
      if /[\u0591-\u07FF\uFB1D-\uFDFD\uFE70-\uFEFC]/.match(IO.read(path))
        'right-to-left'
      else
        'left-to-right'
      end
    else
      dir
    end
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
      mogrify.direction direction if direction
      mogrify.gravity 'Center'
      # While we convert to png, imagemagick will still output the format given
      # by the extension. This allows users to costumize the output with the
      # outfile extension.
      mogrify << '-format png'
      mogrify.trim
      mogrify.resize '25%'
      mogrify << '+repage'
      mogrify.crop "#{ options[:width] }x#{ options[:height] }+0+0"
      mogrify.extent "#{ options[:width] }x#{ options[:height] }"
      mogrify << '+repage'
      mogrify.write outfile
      mogrify << "label:@#{path}"
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
