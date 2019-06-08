require 'isomorfeus-react-base'

# basics
require 'react/component/native_component_validate_prop'
require 'react/component/event_handler'
require 'react/component/api'
require 'react/component/callbacks'
require 'react/component/resolution'
require 'react/component/state'
require 'react/component/should_component_update'
require 'react/redux_component/api'
require 'react/redux_component/app_store_defaults'
require 'react/redux_component/component_class_store_defaults'
require 'react/redux_component/component_instance_store_defaults'
require 'react/redux_component/app_store_proxy'
require 'react/redux_component/class_store_proxy'
require 'react/redux_component/instance_store_proxy'
require 'react/redux_component/reducers'

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
