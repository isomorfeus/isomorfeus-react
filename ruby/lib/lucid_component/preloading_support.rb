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

        def while_loading(option = nil, &block)
          if on_ssr?
            given_block = block
            block = proc {
              promise = instance_exec(&`base.preload_block`)
              if promise.resolved?
                instance_exec(&`base.render_block`)
              else
                instance_exec(&given_block)
              end
            }
          end
          `base.while_loading_block = block`
        end
      end

      def preloaded?
        !!state.preloaded
      end
    end
  end
end
