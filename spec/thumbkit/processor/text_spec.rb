require 'spec_helper'

describe Thumbkit::Processor::Text do

  let(:fixture) { 'text_file.txt' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:outfile) { nil }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Text.new(path, outfile, options) }
  subject { processor }

  its(:path) { should == path }

  describe '#write' do
    let(:outfile) { path_for_output('text-test.png').to_s }
    subject { processor.write }

    it 'returns the path of the outfile' do
      subject.should == outfile
    end

    it 'returns the name of the outfile' do
      File.basename(subject).should == 'text-test.png'
    end

    it 'writes a file' do
      File.should exist(subject)
    end

    its_size_should_be('200x200')

    context 'with size settings' do
      let(:outfile) { path_for_output('text-test-300x250').to_s }
      # Let's change a few settings for manual inspection
      let(:options) { { width: 300, height: 250, colors: { background: :transparent, foreground: '#334455' } } }

      its_size_should_be('300x250')
      # Manually check the file to verify colors
    end

    context 'with some greek letters' do
      let(:fixture) { 'greek.txt' }
      let(:outfile) { path_for_output('greek.png').to_s }
      it('writes a file') { File.should exist(subject) }
      its_size_should_be('200x200')
      # Manually check the file to verify unicode stuff worked
    end

    context 'with an arabic file' do
      let(:options) { { font: { direction: 'right-to-left' } } }
      let(:fixture) { 'arabic.txt' }
      let(:outfile) { path_for_output('arabic.png').to_s }
      it('writes a file') { File.should exist(subject) }
      its_size_should_be('200x200')
      # Manually check the file to verify unicode stuff and right-to-left worked
    end

    context 'with an hebrew file' do
      let(:options) { { font: { direction: 'right-to-left', size: '12' }, width: 400 } }
      let(:fixture) { 'hebrew.txt' }
      let(:outfile) { path_for_output('hebrew.png').to_s }
      it('writes a file') { File.should exist(subject) }
      its_size_should_be('400x200')
      # Manually check the file to verify unicode stuff and right-to-left worked
    end

  end
end
