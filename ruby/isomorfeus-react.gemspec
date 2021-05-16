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

  # s.post_install_message = <<~TEXT
  #
  # isomorfeus-react #{React::VERSION}:
  #  Breaking change:
  #    The event_handler DSL is gone. Instead use normal methods and method_ref, see:
  #    https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/events.md
  #
  # TEXT

  s.add_dependency 'concurrent-ruby', '~> 1.1.8'
  s.add_dependency 'oj', '>= 3.11.0'
  s.add_dependency 'opal', '>= 1.0.0'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'opal-zeitwerk', '~> 0.2.0'
  s.add_dependency 'opal-webpack-loader', '>= 0.10.1'
  s.add_dependency 'isomorfeus-redux', '~> 4.1.1'
  s.add_dependency 'isomorfeus-speednode', '~> 0.3.1'
  s.add_dependency 'dalli', '>= 2.7.0'
  s.add_dependency 'redis', '>= 4.2.0'
  s.add_dependency 'zeitwerk', '~> 2.4.2'
  s.add_development_dependency 'isomorfeus-puppetmaster', '~> 0.4.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.8'
end
