module React
  module ReduxComponent
    module Initializer
      def initialize(native_component)
        @native = native_component
        @app_store = `Opal.React.ReduxComponent.AppStoreProxy.$new(#{self})`
        @class_store = `Opal.React.ReduxComponent.ClassStoreProxy.$new(#{self})`
        @props = `Opal.React.Component.Props.$new(#@native)`
        @state = `Opal.React.Component.State.$new(#@native)`
        @store = `Opal.React.ReduxComponent.InstanceStoreProxy.$new(#{self})`
      end
    end
  end
end
