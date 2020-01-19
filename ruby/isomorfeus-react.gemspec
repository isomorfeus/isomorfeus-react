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
  s.metadata      = { "github_repo" => "ssh://github.com/isomorfeus/gems" }
  s.files         = `git ls-files -- {lib,LICENSE,README.md}`.split("\n")
  #s.test_files    = `git ls-files -- {test,s,features}/*`.split("\n")
  s.require_paths = ['lib']

  #s.post_install_message = <<~TEXT
  #
  #isomorfeus-react #{React::VERSION}:
  #  Major improvement:
  #    Using Zeitwerk and Opal-Zeitwerk for autoloading, may break existing installations which use opal-autoloader.
  #    - existing installations may lock isomorfeus-react to 16.11.1 or upgrade to isomorfeus 1.0.0.zeta6
  #    - new installations with isomorfeus 1.0.0.zeta5 should lock to 16.11.1
  #    - new installations with isomorfeus 1.0.0.zeta6 and up -> enjoy the latest isomorfeus-react
  #
  #TEXT

  s.add_dependency 'concurrent-ruby', '~> 1.1.0'
  s.add_dependency 'oj', '>= 3.10'
  s.add_dependency 'opal', '>= 1.0.0'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'opal-zeitwerk', '~> 0.2.0'
  s.add_dependency 'opal-webpack-loader', '>= 0.9.10'
  s.add_dependency 'isomorfeus-redux', '~> 4.0.17'
  s.add_dependency 'isomorfeus-speednode', '~> 0.2.11'
  s.add_dependency 'zeitwerk', '~> 2.2.2'
  s.add_development_dependency 'isomorfeus-puppetmaster', '~> 0.3.4'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.8'
end
