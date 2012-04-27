require 'spec_helper'

describe Thumbkit, '.defaults' do
  subject { Thumbkit.defaults }

  it 'returns defaults for colors' do
    subject.should have_key(:colors)
  end

  it 'returns defaults for font' do
    subject.should have_key(:font)
  end
end

describe Thumbkit::Defaults do
  describe '#merge' do
    it "does a deep merge" do
      h1 = { x: { y: [4, 5, 6], z: [7, 8, 9], a: 'abar' } }
      h2 = { x: { y: [1, 2, 3], z: 'xyz', b: 'baz' } }
      defaults = Thumbkit::Defaults.new(h1)
      defaults.merge(h2).should == {
        x: {
          y: [1, 2, 3],
          z: 'xyz',
          a: 'abar',
          b: 'baz',
        }
      }
    end

    it "does an even deeper merge" do
      h1 = { colors: { background: 'blue' }, font: { family: { name: 'Helvetica', weight: 'bold' } } }
      h2 = { colors: { foreground: 'black' }, font: { family: { weight: 'light', transform: 'small-caps' } } }
      defaults = Thumbkit::Defaults.new(h1)
      defaults.merge(h2).should == {
        colors: {
          background: 'blue',
          foreground: 'black',
        },
        font: {
          family: {
            name: 'Helvetica',
            weight: 'light',
            transform: 'small-caps',
          }
        }
      }
    end
  end
end
