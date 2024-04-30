require 'react/core_ext/kernel'

if RUBY_ENGINE == 'opal'
  require 'active_support/core_ext/string'
  require 'native'

  if on_browser?
    require 'browser/event'
    require 'browser/event_target'
    require 'browser/delegate_native'
    require 'browser/element'
  end

  require 'server/react/config'

  # allow mounting of components
  if on_browser?
    require 'browser/react/top_level'
  else
    require 'server/react/top_level'
  end

  # react
  require 'react/version'
  require 'react'
  require 'react/synthetic_event'
  require 'react/ref'
  require 'react/children'
  if on_browser?
    require 'browser/react/dom'
  else
    require 'server/react/dom'
  end

  # props
  require 'react/component/props/validate_hash_proxy'
  require 'react/component/props/validator'
  require 'react/component/props/declaration'
  require 'react/component/props'

  # HTML Elements support
  require 'react/component/elements'

  # React Features
  require 'react/component/features'
  require 'react/context_wrapper'
  require 'react/native_constant_wrapper'

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

  # React::FunctionComponent
  require 'react/function_component/api'
  require 'react/function_component/initializer'
  require 'react/function_component/native_component_constructor'
  require 'react/function_component/mixin'
  require 'react/function_component/base'

  # React::MemoComponent
  require 'react/memo_component/native_component_constructor'
  require 'react/memo_component/mixin'
  require 'react/memo_component/base'

  class Object
    include React::Component::Resolution
  end
else
  require 'uri'
  require 'json'
  require 'opal'
  require 'opal-activesupport'
  require 'speednode'
  require 'react/version'
  require 'server/react/config'

  # props
  require 'react/component/props/validate_hash_proxy'
  require 'react/component/props/validator'
  require 'react/component/props/declaration'
  require 'react/component/props'

  React.server_side_rendering = false

  require 'server/react/view_helper'

  Opal.append_path(__dir__)
end
