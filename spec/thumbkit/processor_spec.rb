require 'spec_helper'

describe Thumbkit::Processor do
  describe '.processor_for' do

    subject { Thumbkit::Processor.processor_for(extension) }
    context 'for a .txt' do
      let(:extension) { 'txt' }
      it { should == Thumbkit::Processor::Text }
    end

  end
end
