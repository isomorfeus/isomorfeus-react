module React
  module ReduxComponent
    module Initializer
      def initialize(native_component)
        @native = native_component
        @app_store = ::React::ReduxComponent::AppStoreProxy.new(self)
        @class_store = ::React::ReduxComponent::ClassStoreProxy.new(self)
        @props = ::React::Component::Props.new(@native.JS[:props])
        @state = ::React::Component::State.new(@native)
        @store = ::React::ReduxComponent::InstanceStoreProxy.new(self)
      end
    end
  end
end
