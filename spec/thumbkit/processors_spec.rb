require 'spec_helper'

describe Thumbkit::Processors do
  describe '.processor_for' do

    subject { Thumbkit::Processors.processor_for(extension) }
    context 'for a .txt' do
      let(:extension) { 'txt' }
      it { should == Thumbkit::Processors::Text }
    end

  end
end
