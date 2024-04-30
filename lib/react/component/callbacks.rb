module React
  class Component
    module Callbacks
      def self.included(base)
        base.instance_exec do
          def component_did_catch(&block)
            # TODO convert error and info
            %x{
              var fun = function(error, info) {
                #{`this.__ruby_instance`.instance_exec(`error`, `info`, &block)};
              }
              self.react_component.prototype.componentDidCatch = fun;
            }
          end

          def component_did_mount(&block)
            %x{
              let fun = function() {
                #{`this.__ruby_instance`.instance_exec(&block)};
              }
              self.react_component.prototype.componentDidMount = fun;
            }
          end

          def component_did_update(&block)
            %x{
              var fun = function(prev_props, prev_state, snapshot) {
                #{`this.__ruby_instance`.instance_exec(`Opal.React.Component.Props.$new({props: prev_props})`,
                                                       `Opal.React.Component.State.$new({state: prev_state})`,
                                                       `snapshot`, &block)};
              }
              self.react_component.prototype.componentDidUpdate = fun;
            }
          end

          def component_will_unmount(&block)
            %x{
              var fun = function() {
                if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
                #{`this.__ruby_instance`.instance_exec(&block)};
              }
              self.react_component.prototype.componentWillUnmount = fun;
            }
          end

          def get_derived_state_from_error(&block)
            # TODO convert error
            %x{
               var fun = function(error) {
                var result = #{`this.__ruby_instance`.instance_exec(`error`, &block)};
                if (typeof result.$to_n === 'function') { result = result.$to_n() }
                if (result === Opal.nil) { return null; }
                return result;
              }
              self.react_component.prototype.getDerivedStateFromError = fun;
            }
          end

          def get_derived_state_from_props(&block)
            %x{
              var fun = function(props, state) {
                var result = #{`this.__ruby_instance`.instance_exec(`Opal.React.Component.Props.$new({props: props})`,
                                                                     `Opal.React.Component.State.$new({state: state})`, &block)};
                if (typeof result.$to_n === 'function') { result = result.$to_n() }
                if (result === Opal.nil) { return null; }
                return result;
              }
              self.react_component.prototype.getDerivedStateFromProps = fun;
            }
          end

          def get_snapshot_before_update(&block)
            %x{
              var fun = function(prev_props, prev_state) {
                var result = #{`this.__ruby_instance`.instance_exec(`Opal.React.Component.Props.$new({props: prev_props})`,
                                                                    `Opal.React.Component.State.$new({state: prev_state})`, &block)};
                if (result === Opal.nil) { return null; }
                return result;
              }
              self.react_component.prototype.getSnapshotBeforeUpdate = fun;
            }
          end
        end
      end
    end
  end
end
