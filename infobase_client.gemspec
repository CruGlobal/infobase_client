lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infobase/version'

Gem::Specification.new do |gem|
  gem.name          = 'infobase'
  gem.version       = Infobase::VERSION
  gem.authors       = ['Josh Starcher']
  gem.email         = ['josh.starcher@gmail.com']
  gem.description   = 'This gem wraps an API for the Infobase.'
  gem.summary       = 'Push and pull data from the Infobase'
  gem.homepage      = 'https://github.com/CruGlobal/infobase_client'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('activesupport', '~> 0')
  gem.add_dependency('oj', '~> 2.18')
  gem.add_dependency('rest-client', '~> 1.8')
  gem.add_dependency('retryable-rb', '~> 1.1')
end
