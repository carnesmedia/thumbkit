require 'spec_helper'

describe Thumbkit::Processor do
  describe '.processor_for' do
    subject { Thumbkit::Processor.processor_for(extension) }
    context 'for a .txt' do
      let(:extension) { 'txt' }
      it { should == Thumbkit::Processor::Text }
    end

    context 'for a .mp3' do
      let(:extension) { 'mp3' }
      it { should == Thumbkit::Processor::Audio }
    end
  end

  describe '.force_extension' do
    let(:extension) { 'png' }
    subject { Thumbkit::Processor.force_extension path, extension }
    context 'given an mp3 file' do
      let(:path) { 'foo/bar/blah.mp3' }
      it { should == 'foo/bar/blah.png' }
    end
  end

  describe '#initialize' do
    let(:options) { {} }
    subject { Thumbkit::Processor.new('infile.png', 'outfile.png', options) }

    context 'with no options' do
      its(:options) { should == Thumbkit.defaults }
    end

    context 'with some overrides' do
      let(:options) { { width: 250, height: 250 } }

      it 'overrides the options' do
        subject.options[:width].should == 250
        subject.options[:height].should == 250
      end

      it 'but leaves others' do
        subject.options[:colors].should == Thumbkit.defaults[:colors]
      end
    end
  end
end
