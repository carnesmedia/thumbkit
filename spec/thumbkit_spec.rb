require 'spec_helper'

describe Thumbkit do
  context 'a .txt file' do
    subject { Thumbkit.new path_to_fixture('text_file.txt') }

    its(:filename) { should == 'text_file.txt' }
    its(:path) { should == File.expand_path(path_to_fixture('text_file.txt')) }
    its(:processor) { should == Thumbkit::Processor::Text }
    its(:type) { should == 'txt' }
  end

  context 'with a .mp3 file' do
    subject { Thumbkit.new path_to_fixture('16Hz-20kHz-Exp-1f-5sec.mp3') }

    its(:filename) { should == '16Hz-20kHz-Exp-1f-5sec.mp3' }
    its(:path) { should == File.expand_path(path_to_fixture('16Hz-20kHz-Exp-1f-5sec.mp3')) }
    its(:processor) { should == Thumbkit::Processor::Audio }
    its(:type) { should == 'mp3' }
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
