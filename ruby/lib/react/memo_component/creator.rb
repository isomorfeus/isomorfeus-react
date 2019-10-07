module React
  module MemoComponent
    module Creator
      def self.extended(base)
        %x{
          base.equality_checker = null;
          base.react_component = Opal.global.React.memo(function(props) {
            Opal.React.render_buffer.push([]);
            // console.log("memo pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            Opal.React.active_components.push(base);
            let block_result = #{base.new(`props`).instance_exec(&`base.function_block`)};
            if (typeof block_result === "string" || typeof block_result === "number") { Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result); }
            Opal.React.active_components.pop();
            // console.log("memo popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            return Opal.React.render_buffer.pop();
          }, base.equality_checker);
        }

        def props_are_equal?(&block)
          %x{
            base.equality_checker = function (prev_props, next_props) {
              var prev_ruby_props = Opal.React.Component.Props.$new({props: prev_props});
              var next_ruby_props = Opal.React.Component.Props.$new({props: next_props});
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
