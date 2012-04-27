require 'spec_helper'

describe Thumbkit::Processor::Text do
  let(:fixture) { 'text_file.txt' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:processor) { Thumbkit::Processor::Text.new(path, nil, {}) }
  subject { processor }

  its(:path) { should == path }
end
