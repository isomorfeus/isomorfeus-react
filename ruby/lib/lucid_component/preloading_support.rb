module LucidComponent
  module PreloadingSupport
    def preload(&block)
      `self.preload_block = block`
      component_did_mount do
        instance_exec(&self.class().JS[:preload_block]).then do
          set_state({preloaded: true})
        end
      end
    end

    def while_loading(&block)
      `self.while_loading_block = block`
    end
  end
end
