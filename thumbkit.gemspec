# -*- encoding: utf-8 -*-
require File.expand_path('../lib/thumbkit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Amiel Martin"]
  gem.email         = ["amiel@carnesmedia.com"]
  gem.description   = %q{Thumbkit makes thumbnails!}
  gem.summary       = %q{Thumbkit makes thumbnails from a variety of media types.}
  gem.homepage      = "http://github.com/carnesmedia/thumbkit"

  gem.test_files    = Dir['spec/fixtures/*.{mp3,txt,png,PNG,TXT,jpg}']
  gem.files         = Dir['lib/**/*.rb'] + Dir['[A-Z]*'] + gem.test_files
  gem.name          = "thumbkit"
  gem.license       = 'MIT'
  gem.require_paths = ["lib"]
  gem.version       = Thumbkit::VERSION
end
