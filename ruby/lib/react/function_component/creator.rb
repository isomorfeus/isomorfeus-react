module React
  module FunctionComponent
    module Creator
      def self.extended(base)
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
