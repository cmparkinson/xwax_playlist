# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'itunes_xwax_export'
  spec.version       = '0.1.0'
  spec.authors       = ['Christian Parkinson']
  spec.email         = ['chris@parkie.ca']
  spec.summary       = %q{A small utility to parse the iTunes Library XML file and export xwax compatible playlists.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'debase'
  spec.add_development_dependency 'ruby-debug-ide'

  spec.add_dependency 'plist', '~> 3.1'
  spec.add_dependency 'addressable', '~> 2.3.6'
end
