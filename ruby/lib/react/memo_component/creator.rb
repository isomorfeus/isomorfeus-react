module React
  module MemoComponent
    class Creator
      def event_handler(name, &block)
        define_method(name) do |event, info|
          ruby_event = ::React::SyntheticEvent.new(event)
          block.call(ruby_event, info)
        end
        `self[name] = self['$' + name]`
      end

      def memo(&block)
        component_name = component_name = self.name.gsub('::', '.')
        React.memo(component_name, &block)
      end

      def create_component(&block)
        component_name = self.name.gsub('::', '.')
        %x{
          var fun = Opal.global.React.memo(function(props) {
            Opal.React.render_buffer.push([]);
            Opal.React.active_components.push(self);
            #{new(`props`).instance_exec(&block)};
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
