module LucidComponent
  module PreloadingSupport
    def self.included(base)
      base.instance_exec do
        def preload(&block)
          `base.preload_block = block`
          component_did_mount do
            instance_exec(&self.class.JS[:preload_block]).then do
              self.state.preloaded = true
            end
          end
        end

        def while_loading(&block)
          `base.while_loading_block = block`
        end
      end

      def preloaded?
        !!state.preloaded
      end
    end
  end
end
