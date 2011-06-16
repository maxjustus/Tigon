# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tigon/version"

Gem::Specification.new do |s|
  s.name        = "tigon"
  s.version     = Tigon::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Max Justus Spransy"]
  s.email       = ["maxjustus@gmail.com"]
  s.homepage    = "https://github.com/maxjustus/Tigon"
  s.summary     = %q{A simple dsl for hash transformation.}
  s.description = %q{
      Tigon provides a declarative syntax for transforming hashes. 
    }

  s.rubyforge_project = "tigon"

  s.add_development_dependency 'rspec', '~> 2.5.0'
  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
