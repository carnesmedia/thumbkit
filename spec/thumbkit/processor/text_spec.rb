require 'spec_helper'

describe Thumbkit::Processor::Text do

  def self.its_size_should_be(size)
    it "its size should be #{size}" do
      r = `identify -ping -quiet -format "%wx%h" "#{subject}"`.chomp
      r.should == size
    end
  end



  let(:fixture) { 'text_file.txt' }
  let(:path) { File.expand_path(path_to_fixture(fixture)) }
  let(:outfile) { nil }
  let(:options) { {} }
  let(:processor) { Thumbkit::Processor::Text.new(path, outfile, options) }
  subject { processor }

  its(:path) { should == path }

  describe '#write' do
    let(:outfile) { tmp_path.join('outfile.png').to_s }
    subject { processor.write }

    it 'returns the path of the outfile' do
      subject.should == outfile
    end

    it 'returns the name of the outfile' do
      File.basename(subject).should == 'outfile.png'
    end

    it 'writes a file' do
      File.should exist(subject)
    end

    its_size_should_be('200x200')
  end
end
