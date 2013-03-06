# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traffic_spy/version'

Gem::Specification.new do |gem|
  gem.name          = "traffic_spy"
  gem.version       = TrafficSpy::VERSION
  gem.authors       = ["Geoffrey Schorkopf", "Bradley Sheehan"]
  gem.email         = ["gschorkopf@gmail.com"]
  gem.description   = %q{TrafficSpy commits payloads, events, and campaign details and relays them back in a pretty way.}
  gem.summary       = %q{See description.}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.add_dependency "sinatra", "1.3.5"
  gem.add_dependency "sequel", "3.44.0"
  gem.add_dependency "pg", "0.14.1"

  gem.add_development_dependency "sqlite3", "1.3.5"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
