module React
  module FunctionComponent
    class Creator
      def self.event_handler(name, &block)
        # TODO check, redesign FunctionComponent
        %x{
          Opal.React.FunctionComponent.Runner.event_handlers[name] = function(event, info) {
            #{ruby_event = ::React::SyntheticEvent.new(`event`)};
            #{React::FunctionComponent::Runner.new(`{}`).instance_exec(ruby_event, `info`, &block)};
          }
        }
      end

      def self.function_component(component_name, &block)
        %x{
          var fun = function(props) {
            Opal.React.render_buffer.push([]);
            Opal.React.active_components.push(Opal.React.FunctionComponent.Runner.event_handlers);
            #{React::FunctionComponent::Runner.new(`props`).instance_exec(&block)};
            Opal.React.active_components.pop();
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

      def self.memo_component(component_name, &block)
        %x{
          var fun = Opal.global.React.memo(function(props) {
            Opal.React.render_buffer.push([]);
            Opal.React.active_components.push(Opal.React.FunctionComponent.Runner.event_handlers);
            #{React::FunctionComponent::Runner.new(`props`).instance_exec(&block)};
            Opal.React.active_components.pop();
            return Opal.React.render_buffer.pop();
          });
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
