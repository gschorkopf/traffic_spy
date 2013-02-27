# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traffic_spy/version'

Gem::Specification.new do |gem|
  gem.name          = "traffic_spy"
  gem.version       = TrafficSpy::VERSION
  gem.authors       = ["Geoffrey Schorkopf", "Bradley Sheehan"]
  gem.email         = ["gschorkopf@gmail.com", "bradpsheehan@gmail.com"]
  gem.description   = %q{Traffic Spy is a simple web analytics tool. Post an app name and send payloads to view cool data.}
  gem.summary       = %q{A simple web analytics tool.}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
