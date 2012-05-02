# -*- encoding: utf-8 -*-
require File.expand_path('../lib/thumbkit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Amiel Martin"]
  gem.email         = ["amiel@carnesmedia.com"]
  gem.description   = %q{Thumbkit makes thumbnails!}
  gem.summary       = %q{Thumbkit makes thumbnails from a variety of media types.}
  gem.homepage      = "http://github.com/carnesmedia/thumbkit"

  # TODO: Remove dependency on git
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "thumbkit"
  gem.require_paths = ["lib"]
  gem.version       = Thumbkit::VERSION
end
