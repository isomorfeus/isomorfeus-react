module React
  module Component
    module UnsafeAPI
      def self.included(base)
        base.instance_exec do
          def unsafe_component_will_mount(&block)
            %x{
              self.react_component.prototype.UNSAFE_componentWillMount = function() {
                return #{`this.__ruby_instance`.instance_exec(&block)};
              }
            }
          end

          def unsafe_component_will_receive_props(&block)
            %x{
              self.react_component.prototype.UNSAFE_componentWillReceiveProps = function(next_props) {
                return #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`next_props`), &block)};
              }
            }
          end

          def unsafe_component_will_update(&block)
            %x{
              self.react_component.prototype.UNSAFE_componentWillUpdate = function(next_props, next_state) {
                return #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`next_props`), `Opal.Hash.$new(next_state)`, &block)};
              }
            }
          end
        end
      end
    end
  end
end