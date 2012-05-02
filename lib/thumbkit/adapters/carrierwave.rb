# Example usage:
#
#   class MyUploader < CarrierWave::Uploader::Base
#     include Thumbkit::Adapters::CarrierWave
#
#     version :thumbnail, :if => :valid_for_thumbkit? do
#       # See [Configuration](#configuration) below for more about options.
#       process thumbkit: [200, 200, { colors: { foreground: '#cccccc' } }]
#
#       # This tells CarrierWave where the version file can be found since
#       # thumbkit can write a to a file with a different extension than the
#       # original.
#       #
#       # See https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Customize-your-version-file-names
#       # for more about
#       def full_filename(for_file = model.file.file)
#         [version_name, thumbkit_filename(for_file)].join('_')
#       end
#     end
#   end
#
module Thumbkit::Adapters::CarrierWave
  def thumbkit(width, height, options = {})
    options.merge!(width: width, height: height)
    cache_stored_file! if !cached?
    thumbkit = Thumbkit.new(current_path)
    result = thumbkit.write_thumbnail(nil, options)
    @file = CarrierWave::SanitizedFile.new(result)
  end

  def valid_for_thumbkit?(file)
    p "valid_for_thumbkit?", file, current_path
    !! Thumbkit.new(file.path)
  rescue ArgumentError
    false
  end

  # Given a filename, return the filename that Thumbkit would generate.
  # This should not do any processing.
  def thumbkit_filename(for_file)
    File.basename(Thumbkit.new(for_file).processor_instance.outfile)
  rescue ArgumentError
    # TODO: Handle this case better
    nil
  end
end
