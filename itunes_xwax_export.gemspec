# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itunes_xwax_export/version'

Gem::Specification.new do |spec|
  spec.name          = 'itunes_xwax_export'
  spec.version       = ItunesXwaxExport::VERSION
  spec.authors       = ['Christian Parkinson']
  spec.email         = ['chris@parkie.ca']
  spec.summary       = %q{A small utility to parse the iTunes Library XML file are export xwax compatible playlists.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'nokogiri', '~> 1.6.2'
end
