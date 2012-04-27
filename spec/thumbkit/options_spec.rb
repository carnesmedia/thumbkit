require 'spec_helper'

describe Thumbkit::Options do
  describe '#merge' do
    it "does a deep merge" do
      h1 = { x: { y: [4, 5, 6], z: [7, 8, 9], a: 'abar' } }
      h2 = { x: { y: [1, 2, 3], z: 'xyz', b: { c: 'd' } } }
      defaults = Thumbkit::Options.new(h1)
      defaults.merge(h2).should == {
        x: {
          y: [1, 2, 3],
          z: 'xyz',
          a: 'abar',
          b: { c: 'd' },
        }
      }
    end

    it "does an even deeper merge" do
      # NOTE: These options resemble, but don't actually reflect the available
      #   options for Thumbkit.
      h1 = { colors: { background: 'blue' }, font: { family: { name: 'Helvetica', weight: 'bold' } } }
      h2 = { colors: { foreground: 'black' }, font: { family: { weight: 'light', transform: 'small-caps' } } }
      defaults = Thumbkit::Options.new(h1)
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
