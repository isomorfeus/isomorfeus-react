module LucidComponent
  module PreloadingSupport
    def self.included(base)
      base.instance_exec do
        def preload(&block)
          `base.preload_block = block`
          component_did_mount do
            @_preload_promise.then { self.state.preloaded = true } unless self.state.preloaded
          end
        end

        def while_loading(option = nil, &block)
          wl_block = proc do
            if @_preload_promise.resolved?
              instance_exec(&`base.render_block`)
            else
              instance_exec(&block)
            end
          end
          `base.while_loading_block = wl_block`
        end
      end

      def execute_preload_block
        @_preload_promise = instance_exec(&self.class.JS[:preload_block])
        @_preload_promise.resolved?
      end

      def preloaded?
        !!state.preloaded
      end
    end
  end
end
