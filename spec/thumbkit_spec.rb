require 'spec_helper'

describe Thumbkit do
  context 'with some text' do
    subject { Thumbkit.new path_to_fixture('text_file.txt') }

    its(:filename) { should == 'text_file.txt' }
    its(:path) { should == File.expand_path(path_to_fixture('text_file.txt')) }
    its(:processor) { should be_kind_of(Thumbkit::Processors::Text) }
    its(:type) { should == 'txt' }
  end
end
