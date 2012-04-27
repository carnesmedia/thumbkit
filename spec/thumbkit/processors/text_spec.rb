require 'spec_helper'

describe Thumbkit::Processors::Text do
  let(:fixture) { 'text_file.txt' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:processor) { Thumbkit::Processors::Text.new(path) }
  subject { processor }

  its(:path) { should == path }
end
