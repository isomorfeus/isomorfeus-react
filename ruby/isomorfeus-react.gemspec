# -*- encoding: utf-8 -*-
require_relative 'lib/react/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-react'
  s.version       = React::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'http://isomorfeus.com'
  s.summary       = 'React for Opal Ruby.'
  s.license       = 'MIT'
  s.description   = 'Write React Components in Ruby.'

  s.files         = `git ls-files -- {lib,LICENSE,readme.md}`.split("\n")
  #s.test_files    = `git ls-files -- {test,s,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'opal', '>= 0.11.0'
  s.add_dependency 'opal-activesupport', '~> 0.3.1'
  s.add_dependency 'opal-browser', '~> 0.2.0'
  s.add_dependency 'isomorfeus-redux', '~> 4.0.1'
  s.add_dependency 'isomorfeus-speednode', '~> 0.2.1'
end
