module React
  module MemoComponent
    module Creator
      def self.extended(base)
        %x{
          base.equality_checker = null;
          base.react_component = Opal.global.React.memo(function(props) {
            Opal.React.render_buffer.push([]);
            Opal.React.active_components.push(base);
            #{base.new(`props`).instance_exec(&`base.function_block`)};
            Opal.React.active_components.pop();
            return Opal.React.render_buffer.pop();
          }, base.equality_checker);
        }

        def props_are_equal?(&block)
          %x{
            base.equality_checker = function (prev_props, next_props) {
              var prev_ruby_props = Opal.React.Component.Props.$new(prev_props);
              var next_ruby_props = Opal.React.Component.Props.$new(next_props);
              return #{base.new(`{}`).instance_exec(`prev_ruby_props`, `next_ruby_props`, &block)};
            }
          }
        end

        def create_memo(&block)
          `base.function_block = #{block}`
        end
      end
    end
  end
end
