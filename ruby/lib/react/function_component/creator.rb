module React
  module FunctionComponent
    module Creator
      def self.extended(base)
        # # language=JS
        %x{
          base.react_component = function(props) {
            Opal.React.render_buffer.push([]);
            Opal.React.active_components.push(self);
            var instance = #{base.new(`props`)};
            #{`instance`.instance_exec(&`base.function_block`)};
            Opal.React.active_components.pop();
            return Opal.React.render_buffer.pop();
          }
        }

        def event_handler(name, &block)
          define_method(name) do |event, info|
            ruby_event = ::React::SyntheticEvent.new(event)
            block.call(ruby_event, info)
          end
          `self[name] = self['$' + name]`
        end

        def create_function(&block)
          `base.function_block = #{block}`
        end
      end
    end
  end
end
