module LucidComponent
  module Initializer
    def initialize(native_component)
      @native = native_component
      @app_store = `Opal.LucidComponent.AppStoreProxy.$new(#{self}, 'props')`
      @class_store = `Opal.LucidComponent.ClassStoreProxy.$new(#{self}, 'props')`
      @props = `Opal.React.Component.Props.$new(#@native)`
      @state = `Opal.React.Component.State.$new(#@native)`
      @store = `Opal.LucidComponent.InstanceStoreProxy.$new(#{self}, 'props')`
    end
  end
end
