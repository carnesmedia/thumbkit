require 'spec_helper'

describe Thumbkit::Processor::Image do

  let(:fixture) { 'png_image.png' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:outfile) { nil }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Image.new(path, outfile, options) }
  subject { processor }

  its(:path) { should == path }

  describe '#auto_outflie' do
    subject { processor.outfile }
    context 'when nothing specified' do
      it { should == File.expand_path(path_to_fixture('png_image.png')) }

      context 'when the fixture is a jpeg' do
        let(:fixture) { 'jpg_image.jpg' }
        it { should == File.expand_path(path_to_fixture('jpg_image.jpg')) }
      end
    end

    context 'with an extensionless outfile' do
      let(:outfile) { 'foo.' }
      it { should == 'foo.png' }
    end
  end

  describe '#write' do
    let(:outfile) { path_for_output('png_image.png').to_s }
    subject { processor.write }

    it 'returns the path of the outfile' do
      subject.should == outfile
    end

    it 'writes a file' do
      File.should exist(subject)
    end

    its_size_should_be('200x200')
    its_mimetype_should_be('image/png')

    context 'with size settings' do
      let(:outfile) { path_for_output('resize_test_300x250.png').to_s }
      # Let's change a few settings for manual inspection
      let(:options) { { width: 300, height: 250 } }

      its_size_should_be('300x250')
      its_mimetype_should_be('image/png')
    end

   context 'with size settings larger than the image' do
      let(:outfile) { path_for_output('resize_test_600x600.png').to_s }
      # Let's change a few settings for manual inspection
      let(:options) { { width: 600, height: 600 } }

      its_size_should_be('600x600')
      its_mimetype_should_be('image/png')
    end

    context 'with a jpg file' do
      let(:outfile) { path_for_output('jpg_image.jpg').to_s }
      its_size_should_be('200x200')
      its_mimetype_should_be('image/jpeg')
    end
  end
end
