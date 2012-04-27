require 'spec_helper'

describe Thumbkit::Processor::Audio do

  let(:fixture) { '16Hz-20kHz-Exp-1f-5sec.mp3' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:outfile) { nil }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Audio.new(path, outfile, options) }
  subject { processor }

  its(:path) { should == path }

  describe '#write' do
    let(:outfile) { tmp_path.join('audio-test.png').to_s }
    subject { processor.write }

    it 'returns the path of the outfile' do
      subject.should == outfile
    end

    it 'writes a file' do
      File.should exist(subject)
    end

    its_size_should_be('200x200')
  end
end