require 'thumbkit'

def path_to_fixture(fixture_name)
  "spec/fixtures/#{ fixture_name }"
end


def tmp_path
  Pathname.new('spec/tmp')
end


RSpec.configure do |config|
  # config.around(:each) do |example|
  #   Dir.mkdir(tmp_path)
  #   example.run
  #   File.rm_rf(tmp_path)
  # end
end
