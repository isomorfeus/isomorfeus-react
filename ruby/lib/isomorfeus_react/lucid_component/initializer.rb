module LucidComponent
  module Initializer
    def initialize(native_component)
      @native = native_component
      @app_store = LucidComponent::AppStoreProxy.new(self)
      @class_store = LucidComponent::ClassStoreProxy.new(self)
      @props = `Opal.React.Component.Props.$new(#@native)`
      @state = `Opal.React.Component.State.$new(#@native)`
      @store = LucidComponent::InstanceStoreProxy.new(self)
    end
  end
end
