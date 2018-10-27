module React
  module FunctionalComponent
    class Creator
      def self.event_handler(name, &block)
        %x{
          Opal.React.FunctionalComponent.Runner.event_handlers[name] = function(event, info) {
            #{ruby_event = ::React::SyntheticEvent.new(`event`)};
            #{React::FunctionalComponent::Runner.new(`{}`).instance_exec(ruby_event, `info`, &block)};
          }
        }
      end

      def self.functional_component(component_name, &block)

        %x{
          var fun = function(props) {
            Opal.React.render_buffer.push([]);
            #{React::FunctionalComponent::Runner.new(`props`).instance_exec(&block)};
            return Opal.React.render_buffer.pop();
          }
          var const_names;
          if (component_name.includes('.')) {
            const_names = component_name.split('.');
          } else {
            const_names = [component_name];
          }
          var const_last = const_names.length - 1;
          const_names.reduce(function(prev, curr) {
            if (prev && prev[curr]) {
              return prev[curr];
            } else {
              if (const_names.indexOf(curr) === const_last) {
                prev[curr] = fun;
                return prev[curr];
              } else {
                prev[curr] = {};
                return prev[curr];
              }
            }
          }, Opal.global);
        }
      end
    end
  end
end
