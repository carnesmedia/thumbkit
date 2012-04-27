require 'thumbkit'
require 'fileutils'

def path_to_fixture(fixture_name)
  Pathname.new("spec/fixtures/#{ fixture_name }").expand_path
end


def tmp_path
  Pathname.new('spec/tmp').expand_path
end

RSpec.configure do |config|
  def mkdir_safe(dir)
    Dir.mkdir(dir)
  rescue Errno::EEXIST
    # Great, it's already there.
  end

  config.around(:each) do |example|
    mkdir_safe tmp_path.to_s
    example.run
    FileUtils.rm_rf(tmp_path.to_s)
  end
end
