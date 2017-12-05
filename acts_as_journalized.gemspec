# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_journalized/version'

Gem::Specification.new do |spec|
  spec.name          = 'acts_as_journalized'
  spec.version       = ActsAsJournalized::VERSION
  spec.authors       = ['Roman Shipiev']
  spec.email         = ['roman@shipiev.pro']
  spec.summary       = %q{Plug-in for Redmine}
  spec.description   = %q{Plug-in uses for tracking and recording changes of attributes in model}
  spec.homepage      = 'https://github.com/shipiev/acts_as_journalized'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rails', '~> 4.1.11'
end
