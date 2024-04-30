# -*- encoding: utf-8 -*-
require_relative 'lib/react/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-react'
  s.version       = React::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'http://isomorfeus.com'
  s.summary       = 'Develop React Components in Ruby with Opal.'
  s.license       = 'MIT'
  s.description   = 'Write standalone React Components or Apps in ruby, render them on the server or integrate React Components into Isomorfeus.'
  s.metadata      = { "github_repo" => "ssh://github.com/isomorfeus/gems" }
  s.files         = `git ls-files -- lib LICENSE README.md`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'json', '~> 2.7.2'
  s.add_dependency 'opal', '>= 1.8.2'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'speednode', '~> 0.8.2'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.13'
end
