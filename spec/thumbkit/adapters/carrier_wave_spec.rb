require 'spec_helper'

# TODO: Actually test carrierwave intergration somehow

describe Thumbkit::Adapters::CarrierWave do
  class TestUploader
    include Thumbkit::Adapters::CarrierWave
  end

  describe '#thumbkit_options' do
    subject { TestUploader.new.thumbkit_options options }

    context 'given a width and a height' do
      let(:options) { [10, 20] }
      it { should == { width: 10, height: 20 } }
    end

    context 'given a width and a height and some options' do
      let(:options) { [10, 20, { crop: false }] }
      it { should == { width: 10, height: 20, crop: false } }
    end

    context 'given only some options' do
      let(:options) { [{ crop: false }] }
      it { should == { crop: false } }
    end

    context 'given nothing' do
      let(:options) { [] }
      it { should == {} }
    end
  end

end
