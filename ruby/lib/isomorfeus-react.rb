if RUBY_ENGINE == 'opal'
  require 'isomorfeus-react-base'
  require 'isomorfeus-react-component'
  require 'isomorfeus-react-redux-component'
  require 'isomorfeus-react-lucid'
else
  require 'oj'
  require 'opal'
  require 'opal-activesupport'
  require 'opal-browser'
  require 'isomorfeus-redux'
  require 'isomorfeus-speednode'
  require 'react/version'
  require 'isomorfeus/config'

  Isomorfeus.env = ENV['RACK_ENV']

  if Isomorfeus.env == 'production'
    Isomorfeus.server_side_rendering = true
  else
    Isomorfeus.server_side_rendering = false
  end

  require 'isomorfeus/execution_environment'
  require 'isomorfeus/react_view_helper'

  Opal.append_path(__dir__.untaint)

  if Dir.exist?('isomorfeus')
    Opal.append_path(File.expand_path('isomorfeus')) unless Opal.paths.include?(File.expand_path('isomorfeus'))
  end
end
