if RUBY_ENGINE == 'opal'
  require 'opal'
  require 'opal-autoloader'
  require 'native'
  require 'promise'
  require 'active_support/core_ext/string'
  require 'react/active_support_support'
  require 'isomorfeus-redux'

  if Isomorfeus.on_browser?
    require 'browser/event'
    require 'browser/event_target'
    require 'browser/delegate_native'
    require 'browser/element'
  end

  require 'isomorfeus/config'

  # allow mounting of components
  if Isomorfeus.on_browser?
    require 'isomorfeus/top_level'
  else
    require 'isomorfeus/top_level_ssr'
  end

  # react
  require 'react/version'
  require 'react'
  require 'react/synthetic_event'
  require 'react/ref'
  require 'react/children'
  if Isomorfeus.on_browser?
    require 'react_dom'
  else
    require 'react_dom_server'
  end

  # props
  require 'isomorfeus/props/validate_hash_proxy'
  require 'isomorfeus/props/validator'
  require 'lucid_prop_declaration/mixin'
  require 'react/component/props'

  # HTML Elements support
  require 'react/component/elements'

  # React Features
  require 'react/component/features'
  require 'react/context_wrapper'
  require 'react/native_constant_wrapper'

  # Function Component
  require 'react/function_component/resolution'
  require 'react/function_component/api'
  require 'react/function_component/event_handler'
  require 'react/function_component/creator'
  require 'react/function_component/mixin'
  require 'react/function_component/base'
  require 'react/memo_component/creator'
  require 'react/memo_component/mixin'
  require 'react/memo_component/base'

  # React::Component
  require 'react/component/api'
  require 'react/component/callbacks'
  # require 'react/component/unsafe_api'
  require 'react/component/initializer'
  require 'react/component/native_component_constructor'
  require 'react/component/state'
  require 'react/component/match'
  require 'react/component/location'
  require 'react/component/history'
  require 'react/component/resolution'
  require 'react/component/should_component_update'
  require 'react/component/event_handler'
  require 'react/component/styles'
  require 'react/component/mixin'
  require 'react/component/base'

  # React::PureComponent
  require 'react/pure_component/native_component_constructor'
  require 'react/pure_component/mixin'
  require 'react/pure_component/base'

  # init component reducers
  require 'lucid_component/reducers'
  LucidComponent::Reducers.add_component_reducers_to_store

  # init LucidApplicationContext (Store Provider and Consumer)
  require 'lucid_app/context'
  LucidApp::Context.create_application_context

  # LucidComponent
  require 'lucid_component/styles_support'
  require 'lucid_component/store_api'
  require 'lucid_component/app_store_defaults'
  require 'lucid_component/component_class_store_defaults'
  require 'lucid_component/component_instance_store_defaults'
  require 'lucid_component/app_store_proxy'
  require 'lucid_component/class_store_proxy'
  require 'lucid_component/instance_store_proxy'
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

  Opal::Autoloader.add_load_path('components')
else
  require 'oj'
  require 'opal'
  require 'opal-activesupport'
  require 'opal-autoloader'
  require 'isomorfeus-redux'
  require 'isomorfeus-speednode'
  require 'react/version'
  require 'isomorfeus/config'

  # props
  require 'isomorfeus/props/validate_hash_proxy'
  require 'isomorfeus/props/validator'
  require 'lucid_prop_declaration/mixin'

  Isomorfeus.env = ENV['RACK_ENV']

  if Isomorfeus.production? || Isomorfeus.test?
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
