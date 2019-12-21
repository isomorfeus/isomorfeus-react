module LucidFunc
  module Initializer
    def initialize
      self.JS[:native_props] = `{ props: null }`
      @native_props = `Opal.React.Component.Props.$new(#{self})`
      @app_store = LucidComponent::AppStoreProxy.new(self)
      @class_store = LucidComponent::ClassStoreProxy.new(self)
      @store = LucidComponent::InstanceStoreProxy.new(self)
      event_handlers = self.class.event_handlers
      event_handler_source = self.class
      %x{
        for (var i = 0; i < event_handlers.length; i++) {
          self[event_handlers[i]] = event_handler_source[event_handlers[i]];
          self[event_handlers[i]] = self[event_handlers[i]].bind(self);
        }
      }
    end
  end
end
