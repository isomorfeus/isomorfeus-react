module React
  module FunctionalComponent
    class Creator
      def self.functional_component(component_name, &block)
        %x{
          Opal.global[#{component_name}] = function(props) {
            Opal.React.render_buffer.push([]);
            #{React::FunctionalComponent::Runner.new(`props`).instance_exec(&block)};
            return Opal.React.render_buffer.pop();
          }
        }
      end
    end
  end
end
