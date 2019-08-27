module LucidComponent
  module Initializer
    def initialize(native_component)
      @native = native_component
      @app_store = `Opal.LucidComponent.AppStoreProxy.$new(#{self})`
      @class_store = `Opal.LucidComponent.ClassStoreProxy.$new(#{self})`
      @props = `Opal.React.Component.Props.$new(#@native)`
      @state = `Opal.React.Component.State.$new(#@native)`
      @store = `Opal.LucidComponent.InstanceStoreProxy.$new(#{self})`
    end
  end
end
