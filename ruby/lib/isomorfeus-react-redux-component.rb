require 'isomorfeus-react-base'
# Component basics
require 'react/component/native_component_validate_prop'
require 'react/component/event_handler'
require 'react/component/api'
require 'react/component/callbacks'
require 'react/component/resolution'
require 'react/component/state'
require 'react/component/should_component_update'
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

# init component reducers
React::ReduxComponent::Reducers.add_component_reducers_to_store