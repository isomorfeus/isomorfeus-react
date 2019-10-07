module React
  module FunctionComponent
    module Creator
      def self.extended(base)
        %x{
          base.react_component = function(props) {
            Opal.React.render_buffer.push([]);
            // console.log("function pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            Opal.React.active_components.push(base);
            let block_result = #{base.new(`props`).instance_exec(&`base.function_block`)};
            if (typeof block_result === "string" || typeof block_result === "number") { Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result); }
            Opal.React.active_components.pop();
            // console.log("function popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            return Opal.React.render_buffer.pop();
          }
        }

        base_module = base.to_s.deconstantize
        if base_module != ''
          base_module.constantize.define_singleton_method(base.to_s.demodulize) do |*args, &block|
            `Opal.React.internal_prepare_args_and_render(#{base}.react_component, args, block)`
          end
        else
          Object.define_method(base.to_s) do |*args, &block|
            `Opal.React.internal_prepare_args_and_render(#{base}.react_component, args, block)`
          end
        end

        def create_function(&block)
          `base.function_block = #{block}`
        end
      end
    end
  end
end
