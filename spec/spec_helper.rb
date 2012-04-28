require 'thumbkit'
require 'fileutils'

module Helpers

  def path_to_fixture(fixture_name)
    Pathname.new("spec/fixtures").join(fixture_name).expand_path
  end

  def tmp_path
    Pathname.new("spec/tmp")
  end

  def path_for_output(outfile = '')
    tmp_path.join(outfile).expand_path
  end
end

module ImageMacros
  def its_size_should_be(size)
    it "its size should be #{size}" do
      r = `identify -ping -quiet -format "%wx%h" "#{subject}"`.chomp
      r.should == size
    end
  end
end

RSpec.configure do |config|
  config.extend ImageMacros
  config.include Helpers

  def mkdir_safe(dir)
    Dir.mkdir(dir)
  rescue Errno::EEXIST
    # Great, it's already there.
  end

  config.around(:each) do |example|
    mkdir_safe tmp_path.to_s
    example.run
    # FileUtils.rm_rf(tmp_path.to_s)
  end
end

