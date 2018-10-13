module LucidApp
  module API
    def self.included(base)
      base.instance_exec do
        def render(&block)
          %x{
            self.react_component.prototype.render = function() {
              Opal.React.render_buffer.push([]);
              Opal.React.active_redux_components.push(this.__ruby_instance);
              #{`this.__ruby_instance`.instance_exec(&block)};
              Opal.React.active_redux_components.pop();
              var children = Opal.React.render_buffer.pop();
              return React.createElement(LucidApplicationContext.Provider, { value: this.state.__isomorfeus_store_state }, children);
            }
          }
        end
      end
    end
  end
end
