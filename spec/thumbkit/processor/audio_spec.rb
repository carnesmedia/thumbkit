require 'spec_helper'

describe Thumbkit::Processor::Audio do

  let(:fixture) { '16Hz-20kHz-Exp-1f-5sec.mp3' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:outfile) { nil }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Audio.new(path, outfile, options) }
  subject { processor }

  its(:path) { should == path }

  describe '#auto_outflie' do
    subject { processor.outfile }
    context 'when nothing specified' do
      it { should == File.expand_path(path_to_fixture('16Hz-20kHz-Exp-1f-5sec.png')) }
    end

    # context 'with an extensionless outfile' do
    #   let(:outfile) { 'foo.' }
    #   it { should == 'foo.png' }
    # end

    # Not sure what to do in this case. Waveform just outputs a png file no
    # matter what...
    #
    # context 'with a jpg specified' do
    #   let(:outfile) { path_for_output('audio-test.jpg').to_s }
    #   before { processor.write }
    #   it { should == path_for_output('audio_test.jpg').to_s }
    # end
  end

  describe '#write' do
    let(:outfile) { path_for_output('audio-test.png').to_s }
    subject { processor.write }

    it 'returns the path of the outfile' do
      subject.should == outfile
    end

    it 'writes a file' do
      File.should exist(subject)
    end

    its_size_should_be('200x200')

    context 'with size settings' do
      let(:outfile) { path_for_output('audio-test-300x250.png').to_s }
      # Let's change a few settings for manual inspection
      let(:options) { { width: 300, height: 250, colors: { background: :transparent, foreground: '#ffeecc' } } }

      its_size_should_be('300x250')
    end
  end
end
