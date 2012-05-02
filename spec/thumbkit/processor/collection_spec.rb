require 'spec_helper'

describe Thumbkit::Processor::Collection do

  let(:fixtures) {
    ['png_file.png', 'text_file.txt', 'jpg_file.jpg', '16Hz-20kHz-Exp-1f-5sec.mp3']
  }
  let(:paths) { fixtures.map { |fixture| File.expand_path(path_to_fixture(fixture)) } }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Collection.new(paths, outfile, options) }
  subject { processor }

  describe '#determine_outfile' do
    let(:outfile) { nil }
    it 'raises an error' do
      expect { processor.determine_outfile }.to raise_error(ArgumentError)
    end
  end

  describe '#collection' do
    let(:outfile) { path_for_output('collection.png').to_s }
    subject { processor.collection }

    it 'returns an array of ThumbkitS' do
      subject.should be_kind_of(Array)
      subject.each { |e| e.should be_kind_of(Thumbkit) }
    end

    it 'there are 4 of them' do
      subject.size.should == 4
    end

    it 'they haz the right paths' do
      subject.map(&:path).should == paths
    end
  end

  describe '#write' do
    let(:outfile) { path_for_output('collection.png').to_s }
    subject { processor.write }

    it 'returns the path of the outfile' do
      subject.should == outfile
    end

    it 'writes a file' do
      File.should exist(subject)
    end

    its_size_should_be('200x200')
    its_mimetype_should_be('image/png')

    context 'with only 3 sources' do
      let(:outfile) { path_for_output('collection-3.png').to_s }
      let(:fixtures) {
        ['png_file.png', 'text_file.txt', 'jpg_file.jpg']
      }

      it 'writes a file' do
        File.should exist(subject)
      end

      its_size_should_be('200x200')
      its_mimetype_should_be('image/png')
    end

    context 'with only 5 sources' do
      let(:outfile) { path_for_output('collection-5.png').to_s }
      let(:fixtures) {
        ['16Hz-20kHz-Exp-1f-5sec.mp3', 'arabic.txt', 'png_file.png', 'text_file.txt', 'jpg_file.jpg']
      }

      it 'writes a file' do
        File.should exist(subject)
      end

      its_size_should_be('200x200')
      its_mimetype_should_be('image/png')
    end
  end
end
