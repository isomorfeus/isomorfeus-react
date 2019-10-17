module LucidComponent
  module PreloadingSupport
    def self.included(base)
      base.instance_exec do
        def preload(&block)
          `base.preload_block = block`
          component_did_mount do
            `base.preload_block`.call.then do
              set_state({preloaded: true})
            end
          end
        end

        def while_loading(&block)
          `base.while_loading_block = block`
        end
      end
    end
  end
end
