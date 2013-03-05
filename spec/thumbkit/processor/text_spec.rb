require 'spec_helper'

describe Thumbkit::Processor::Text do

  let(:fixture) { 'text_file.txt' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:outfile) { nil }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Text.new(path, outfile, options) }
  subject { processor }

  its(:path) { should == path }


  describe '#auto_outflie' do
    subject { processor.outfile }
    context 'when nothing specified' do
      it { should == File.expand_path(path_to_fixture('text_file.png')) }
    end

    # context 'with an extensionless outfile' do
    #   let(:outfile) { 'foo.' }
    #   it { should == 'foo.png' }
    # end
  end

  describe '#write' do
    let(:outfile) { path_for_output('text-test.png').to_s }
    subject { processor.write }

    it 'returns the path of the outfile' do
      subject.should == outfile
    end

    it 'returns the name of the outfile' do
      File.basename(subject).should == 'text-test.png'
    end

    it 'reads the files content' do
      processor.text_content.should == File.read(path)
    end

    it 'writes a file' do
      File.should exist(subject)
    end

    it "doesn't have label in the metadata" do
      result = `identify -verbose #{ subject }|grep label:`.chomp
      result.should be_empty
    end

    its_size_should_be('200x200')
    its_mimetype_should_be('image/png')

    context 'with size settings' do
      let(:outfile) { path_for_output('text-test-300x250.png').to_s }
      # Let's change a few settings for manual inspection
      let(:options) { { width: 300, height: 250, colors: { background: :transparent, foreground: '#334455' } } }

      its_size_should_be('300x250')
      its_mimetype_should_be('image/png')
      # Manually check the file to verify colors
    end


    context 'with size settings specifically for the text processor in defaults' do
      let(:outfile) { path_for_output('text-test-300x250.png').to_s }
      before { Thumbkit.defaults = { Text: { width: 300, height: 250 } } }
      after { Thumbkit.reset_defaults! }

      its_size_should_be('300x250')
      its_mimetype_should_be('image/png')
    end

    context 'with size settings specifically for the text processor' do
      let(:outfile) { path_for_output('text-test-300x250.png').to_s }
      let(:options) { { Text: { width: 300, height: 250 } } }

      its_size_should_be('300x250')
      its_mimetype_should_be('image/png')
    end


    context 'with gravity settings' do
      let(:outfile) { path_for_output('text-test-northeast-150x250.png').to_s }
      # Let's change a few settings for manual inspection
      let(:options) { {
        width: 150, height: 250, gravity: 'NorthEast',
        colors: { background: :transparent, foreground: '#334455' }
      } }

      its_size_should_be('150x250')
      its_mimetype_should_be('image/png')
      # Manually check the file to verify colors and gravity
    end

    context 'with some greek letters' do
      let(:fixture) { 'greek.txt' }
      let(:options) { { width: 400, height: 400 } }
      let(:outfile) { path_for_output('greek.png').to_s }
      it('writes a file') { File.should exist(subject) }
      it('autodetects left-to-right') { processor.direction.should == 'left-to-right' }
      its_size_should_be('400x400')
      its_mimetype_should_be('image/png')
      # Manually check the file to verify unicode stuff worked
    end

    context 'with a large file' do
      let(:fixture) { 'largish_file.txt' }
      let(:options) { {
        # Shorter timeout so the tests don't run so long.
        timeout: 5,
        width: 300, height: 240,
        colors: { foreground: '#808080', background: '#f6f6f4' },
        font: { family: 'Helvetica', pointsize: '16' },
      } }

      let(:outfile) { path_for_output('largish_file.png').to_s }

      # It should not fail anymore
      # it 'raises an error instead of stalling' do
      #   expect { subject }.to raise_error
      # end

      # it('does not write a file') { subject rescue nil; File.should_not exist(subject) }

      it('writes a file') { File.should exist(subject) }
      its_size_should_be('300x240')
      its_mimetype_should_be('image/png')
    end

    context 'given a file with a lot of lines' do
      let(:fixture) { 'long_file.txt' }

      it 'only returns the first few lines' do
        processor.text_content.split("\n").size.should be < 40
      end
    end

    context 'given a file with very long lines' do
      let(:fixture) { 'long_lines.txt' }

      it 'shortens lines' do
        processor.text_content.split("\n").map(&:length).max.should be < 80
      end
    end

    describe 'the line shortener' do
      let(:path) { 'HACK_STUB' }
      let(:test_string) {
<<-TEST_STRING
aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjj
kkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuu
vvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz
aaaaaaaaaa
TEST_STRING
      }

      let(:expected) {
<<-TEST_STRING
aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhh
kkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrr
vvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz
aaaaaaaaaa
TEST_STRING
      }


      before do
        IO.stub(:read).with('HACK_STUB').and_return(test_string)
      end

      it 'shortens lines correctly' do
        processor.text_content.should == expected
      end
    end

    context 'with an arabic file' do
      let(:options) { { font: { direction: :auto } } }
      let(:fixture) { 'arabic.txt' }
      let(:outfile) { path_for_output('arabic.png').to_s }
      it('writes a file') { File.should exist(subject) }
      it('autodetects right-to-left') { processor.direction.should == 'right-to-left' }
      its_size_should_be('200x200')
      its_mimetype_should_be('image/png')
      # Manually check the file to verify unicode stuff and right-to-left worked
    end

    context 'with an hebrew file' do
      let(:options) { { font: { direction: 'right-to-left', size: '12' }, width: 400 } }
      let(:fixture) { 'hebrew.txt' }
      let(:outfile) { path_for_output('hebrew.png').to_s }
      it('writes a file') { File.should exist(subject) }
      it('is right-to-left') { processor.direction.should == 'right-to-left' }
      its_size_should_be('400x200')
      its_mimetype_should_be('image/png')
      # Manually check the file to verify unicode stuff and right-to-left worked
    end

    context 'with an uppercase filename' do
      let(:options) { { } }
      let(:fixture) { 'OMG_UPPERCASE_TEXT.TXT' }
      let(:outfile) { path_for_output('OMG_UPPERCASE_TEXT.PNG').to_s }
      it('writes a file') { File.should exist(subject) }
      its_size_should_be('200x200')
      its_mimetype_should_be('image/png')
    end


    context 'with an arabic file to output to jpg' do
      let(:options) { { width: 600, height: 400 } }
      let(:fixture) { 'arabic.txt' }
      let(:outfile) { path_for_output('arabic.jpg').to_s }
      it('writes a file') { File.should exist(subject) }
      it('autodetects right-to-left') { processor.direction.should == 'right-to-left' }
      its_size_should_be('600x400')
      its_mimetype_should_be('image/jpeg')
      # Manually check the file to verify unicode stuff and right-to-left worked
    end

  end
end
