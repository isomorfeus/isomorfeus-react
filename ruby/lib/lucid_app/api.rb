module LucidApp
  module API
    def self.included(base)
      base.instance_exec do
        def render(&block)
          `base.render_block = block`
        end
      end

      def context
        @native.JS[:context]
      end
    end
  end
end
