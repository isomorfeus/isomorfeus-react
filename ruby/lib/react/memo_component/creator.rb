module React
  module MemoComponent
    module Creator
      def self.extended(base)
        %x{
          base.react_component = Opal.global.React.memo(function(props) {
            Opal.React.render_buffer.push([]);
            Opal.React.active_components.push(self);
            var instance = #{base.new(`props`)};
            #{`instance`.instance_exec(&`base.function_block`)};
            Opal.React.active_components.pop();
            return Opal.React.render_buffer.pop();
          });
        }

        def create_memo(&block)
          `base.function_block = #{block}`
        end
      end
    end
  end
end
