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
require 'isomorfeus/config'

# allow mounting of components
if Isomorfeus.on_browser?
  require 'isomorfeus/top_level_browser'
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

