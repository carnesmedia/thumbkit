require 'spec_helper'

describe Thumbkit::Processor::Image do

  let(:fixture) { 'png_file.png' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:outfile) { nil }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Image.new(path, outfile, options) }
  subject { processor }

  its(:path) { should == path }

  describe '#auto_outflie' do
    subject { processor.outfile }
    context 'when nothing specified' do
      it { should == File.expand_path(path_to_fixture('png_file.png')) }

      context 'when the fixture is a jpeg' do
        let(:fixture) { 'jpg_file.jpg' }
        it { should == File.expand_path(path_to_fixture('jpg_file.jpg')) }
      end

      context 'when the fixture is a cr2' do
        let(:fixture) { 'IMAGE_RAW_EXAMPLE.CR2' }
        it { should == File.expand_path(path_to_fixture('IMAGE_RAW_EXAMPLE.jpg')) }
      end

      context 'with an uppercase file' do
        let(:fixture) { 'OMG_UPPERCASE.PNG' }
        it { should == File.expand_path(path_to_fixture('OMG_UPPERCASE.png')) }
      end
    end

    # context 'with an extensionless outfile' do
    #   let(:outfile) { 'foo.' }
    #   it { should == 'foo.png' }
    # end
  end

  describe '#write' do
    let(:outfile) { path_for_output('png_file.png').to_s }
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

    context 'with size and gravity settings' do
      let(:outfile) { path_for_output('resize_test_southwest_300x100.png').to_s }
      # Let's change a few settings for manual inspection
      let(:options) { { width: 300, height: 100, gravity: 'SouthWest' } }

      its_size_should_be('300x100')
      its_mimetype_should_be('image/png')
    end

   context 'with size settings and no crop' do
     let(:outfile) { path_for_output('resize_test_300x100_no_crop.png').to_s }
     let(:options) { { width: 300, height: 100, crop: false } }

     its_size_should_be('100x100')
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
      let(:outfile) { path_for_output('jpg_file.jpg').to_s }
      it { should == path_for_output('jpg_file.jpg').to_s }
      its_size_should_be('200x200')
      its_mimetype_should_be('image/jpeg')
    end

    context 'with an uppercase file' do
      let(:fixture) { path_to_fixture('OMG_UPPERCASE.PNG') }
      let(:outfile) { path_for_output('OMG_UPPERCASE.png').to_s }
      it { should == path_for_output('OMG_UPPERCASE.png').to_s }
      its_size_should_be('200x200')
      its_mimetype_should_be('image/png')
    end

    context 'when the filename has spaces' do
      let(:fixture) { path_to_fixture('with spaces.png') }
      let(:outfile) { path_for_output('with spaces.png').to_s }
      it { should == path_for_output('with spaces.png').to_s }
      its_size_should_be('200x200')
      its_mimetype_should_be('image/png')
    end


    # Extremely SLOW
    # context 'with a raw file' do
    #   let(:fixture) { 'IMG_RAW_EXAMPLE.CR2' }
    #   let(:outfile) { path_for_output('IMAGE_RAW_EXAMPLE.jpg').to_s }
    #   it { should == path_for_output('IMAGE_RAW_EXAMPLE.jpg').to_s }
    #   its_size_should_be('200x200')
    #   its_mimetype_should_be('image/jpeg')
    # end

    # context 'with a raw file' do
    #   let(:fixture) { 'NIKON_RAW_EXAMPLE.NEF' }
    #   let(:outfile) { path_for_output('NIKON_RAW_EXAMPLE.jpg').to_s }
    #   it { should == path_for_output('NIKON_RAW_EXAMPLE.jpg').to_s }
    #   its_size_should_be('200x200')
    #   its_mimetype_should_be('image/jpeg')
    # end
  end
end
