if RUBY_ENGINE == 'opal'
  # require 'opal'
  # require 'native'
  # require 'promise'
  # rely on i-redux to have included above requirements
  require 'isomorfeus-redux'
  require 'active_support/core_ext/string'
  require 'zeitwerk'

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
  #require 'react/function_component/resolution'
  #require 'react/function_component/initializer'
  #require 'react/function_component/api'
  #require 'react/function_component/event_handler'
  #require 'react/function_component/native_component_constructor'
  #require 'react/function_component/mixin'
  #require 'react/function_component/base'
  #require 'react/memo_component/native_component_constructor'
  #require 'react/memo_component/mixin'
  #require 'react/memo_component/base'

  # React::Component
  require 'react/component/api'
  require 'react/component/callbacks'
  require 'react/component/initializer'
  require 'react/component/native_component_constructor'
  require 'react/component/state'
  require 'react/component/match'
  require 'react/component/location'
  require 'react/component/history'
  require 'react/component/resolution'
  require 'react/component/styles'
  require 'react/component/mixin'
  require 'react/component/base'

  # init component reducers
  require 'lucid_app/reducers'
  LucidApp::Reducers.add_component_reducers_to_store

  # init LucidApplicationContext (Store Provider and Consumer)
  require 'lucid_app/context'
  LucidApp::Context.create_application_context

  # LucidFunc
  #require 'lucid_func/initializer'
  #require 'lucid_func/native_component_constructor'
  #require 'lucid_func/mixin'
  #require 'lucid_func/base'

  # LucidComponent
  #require 'lucid_component/environment_support'
  #require 'lucid_component/api'
  #require 'lucid_component/app_store_defaults'
  #require 'lucid_component/component_class_store_defaults'
  #require 'lucid_component/component_instance_store_defaults'
  #require 'lucid_component/app_store_proxy'
  #require 'lucid_component/class_store_proxy'
  #require 'lucid_component/instance_store_proxy'
  #require 'lucid_component/initializer'
  #require 'lucid_component/native_lucid_component_constructor'
  #require 'lucid_component/native_component_constructor'
  #require 'lucid_component/mixin'
  #require 'lucid_component/base'

  # LucidApp
  #require 'lucid_app/api'
  #require 'lucid_app/native_lucid_component_constructor'
  #require 'lucid_app/native_component_constructor'
  #require 'lucid_app/mixin'
  #require 'lucid_app/base'

  class Object
    include React::Component::Resolution
  end

  # require 'isomorfeus/vivify_module'

  Isomorfeus.zeitwerk = Zeitwerk::Loader.new
  # Isomorfeus.zeitwerk.vivify_mod_dir = 'components/'
  # Isomorfeus.zeitwerk.vivify_mod_class = Isomorfeus::VivifyModule

  Isomorfeus.zeitwerk.push_dir('isomorfeus_react')
  require_tree 'isomorfeus_react', :autoload

  Isomorfeus.zeitwerk.push_dir('components')
else
  require 'uri'
  require 'oj'
  require 'opal'
  require 'opal-activesupport'
  require 'opal-zeitwerk'
  require 'opal-webpack-loader'
  require 'isomorfeus-redux'
  require 'isomorfeus-speednode'
  require 'react/version'
  require 'isomorfeus/config'

  # props
  require 'isomorfeus/props/validate_hash_proxy'
  require 'isomorfeus/props/validator'
  require 'lucid_prop_declaration/mixin'

  Isomorfeus.env = ENV['RACK_ENV']

  if Isomorfeus.development?
    require 'net/http'
    Isomorfeus.ssr_hot_asset_url = 'http://localhost:3036/assets/'
  end

  Isomorfeus.server_side_rendering = true

  # cache
  require 'isomorfeus/thread_local_cache'
  require 'isomorfeus/react_view_helper'

  Isomorfeus.component_cache_class = Isomorfeus::ThreadLocalCache

  Opal.append_path(__dir__.untaint)

  require 'concurrent'
  require 'zeitwerk'

  Isomorfeus.zeitwerk = Zeitwerk::Loader.new
  Isomorfeus.zeitwerk_lock = Concurrent::ReentrantReadWriteLock.new if Isomorfeus.development?
  # nothing to push_dir to zeitwerk here, as components are available only within browser/SSR
end
