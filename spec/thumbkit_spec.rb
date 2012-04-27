require 'spec_helper'

describe Thumbkit do
  context 'with some text' do
    subject { Thumbkit.new path_to_fixture('text_file.txt') }

    its(:filename) { should == 'text_file.txt' }
    its(:path) { should == File.expand_path(path_to_fixture('text_file.txt')) }
    its(:processor) { should == Thumbkit::Processor::Text }
    its(:type) { should == 'txt' }
  end
end


describe Thumbkit, '.defaults' do
  subject { Thumbkit.defaults }

  it 'returns defaults for colors' do
    subject.should have_key(:colors)
  end

  it 'returns defaults for font' do
    subject.should have_key(:font)
  end
end
