if RUBY_ENGINE == 'opal'
  require 'opal'
  require 'native'
  require 'active_support/core_ext/string'
  require 'react/active_support_support'
  require 'isomorfeus/execution_environment'
  if Isomorfeus.on_browser?
    require 'browser/support'
    require 'browser/event'
    require 'browser/event_source'
    require 'browser/screen'
    require 'browser/socket'
    require 'browser/window'
    require 'browser/dom/node'
    require 'browser/dom/element'
  end
  require 'isomorfeus-redux'
  require 'react/version'
  require 'react'
  # require 'react/element' # usually not needed
  require 'react/synthetic_event'
  require 'react/ref'
  require 'react/children'
  if Isomorfeus.on_browser?
    require 'react_dom'
  else
    require 'react_dom_server'
  end
  # React::Component
  require 'react/component/api'
  require 'react/component/unsafe_api'
  require 'react/component/initializer'
  require 'react/component/features'
  require 'react/native_constant_wrapper'
  require 'react/context_wrapper'
  require 'react/component/native_component_constructor'
  require 'react/component/native_component_validate_prop'
  require 'react/component/props'
  require 'react/component/state'
  require 'react/component/match'
  require 'react/component/location'
  require 'react/component/history'
  require 'react/component/elements'
  require 'react/component/resolution'
  require 'react/component/should_component_update'
  require 'react/component/event_handler'
  require 'react/component/mixin'
  require 'react/component/base'
  # React::PureComponent
  require 'react/pure_component/mixin'
  require 'react/pure_component/base'
  # Function Component
  require 'react/function_component/resolution'
  require 'react/function_component/creator'
  require 'react/function_component/mixin'
  require 'react/function_component/base'
  require 'react/memo_component/creator'
  require 'react/memo_component/mixin'
  require 'react/memo_component/base'
  # Redux::Component
  require 'react/redux_component/component_class_store_defaults'
  require 'react/redux_component/component_instance_store_defaults'
  require 'react/redux_component/app_store_defaults'
  require 'react/redux_component/api'
  require 'react/redux_component/initializer'
  require 'react/redux_component/app_store_proxy'
  require 'react/redux_component/class_store_proxy'
  require 'react/redux_component/instance_store_proxy'
  require 'react/redux_component/native_component_constructor'
  require 'react/redux_component/mixin'
  require 'react/redux_component/base'
  require 'react/redux_component/reducers'
  require 'isomorfeus/config'

  # init component reducers
  React::ReduxComponent::Reducers.add_component_reducers_to_store

  # init LucidApplicationContext (Store Provider and Consumer)
  require 'lucid_app/context'

  LucidApp::Context.create_application_context

  # LucidComponent
  require 'lucid_component/api'
  require 'lucid_component/initializer'
  require 'lucid_component/native_component_constructor'
  require 'lucid_component/event_handler'
  require 'lucid_component/mixin'
  require 'lucid_component/base'

  # LucidApp
  require 'lucid_app/api'
  require 'lucid_app/native_component_constructor'
  require 'lucid_app/mixin'
  require 'lucid_app/base'

  # LucidRouter
  require 'lucid_router'

  # allow mounting of components
  if Isomorfeus.on_browser?
    require 'isomorfeus/top_level_browser'
  else
    require 'isomorfeus/top_level_ssr'
  end

  # initalize Store, options, etc.
  Isomorfeus.init
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
