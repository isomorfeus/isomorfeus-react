module LucidComponent
  module Initializer
    def initialize(native_component)
      @native = native_component
      @app_store = ::React::ReduxComponent::AppStoreProxy.new(self, 'props')
      @class_store = ::React::ReduxComponent::ClassStoreProxy.new(self, 'props')
      @props = `Opal.React.Component.Props.$new(#@native.props)`
      @state = `Opal.React.Component.State.$new(#@native)`
      @store = ::React::ReduxComponent::InstanceStoreProxy.new(self, 'props')
    end
  end
end
