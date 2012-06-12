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

  context 'with an array' do
    let(:files) { [path_to_fixture('16Hz-20kHz-Exp-1f-5sec.mp3'), path_to_fixture('text_file.txt')] }
    subject { Thumbkit.new files }

    its(:processor) { should == Thumbkit::Processor::Collection }
  end

  context 'with no extension' do
    subject { Thumbkit.new 'this_file_has_no_extension' }
    it 'raises an ArgumentError' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context 'with an unknown extension' do
    subject { Thumbkit.new 'this_extension.no_exist_i_promise' }
    it 'raises an ArgumentError' do
      expect { subject }.to raise_error(ArgumentError)
    end
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


describe Thumbkit, '.defaults=' do
  subject { Thumbkit.defaults }
  before { Thumbkit.defaults = { font: { family: 'Helvetica' } } }

  it 'still has all the other settings' do
    subject.should have_key(:colors)
  end

  it 'still has the other default font settings' do
    subject[:font].should have_key(:size)
  end

  it 'changes the font family' do
    subject[:font][:family].should == 'Helvetica'
  end
end
