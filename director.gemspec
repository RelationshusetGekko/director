# -*- encoding: utf-8 -*-
require File.expand_path('../lib/director/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jacob Atzen"]
  gem.email         = ["jacob@incremental.dk"]
  gem.description   = %q{Scheduler}
  gem.summary       = %q{Scheduler gem}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\).reject{|f| f.match(/\Aschedule_demo/) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "director"
  gem.require_paths = ["lib"]
  gem.version       = Director::VERSION

  gem.add_runtime_dependency 'activesupport'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', "~> 2.8.0"
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'growl'
end
