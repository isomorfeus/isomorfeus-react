module LucidFunc
  module Initializer
    def initialize
      self.JS[:native_props] = `{ props: null }`
      @native_props = `Opal.React.Component.Props.$new(#{self})`
      @app_store = LucidComponent::AppStoreProxy.new(self)
      @class_store = LucidComponent::ClassStoreProxy.new(self)
      @store = LucidComponent::InstanceStoreProxy.new(self)
    end
  end
end
