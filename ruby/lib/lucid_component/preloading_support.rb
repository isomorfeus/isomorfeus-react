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
          if option == :except_ssr
            `base.except_ssr = true;`
            block = if on_ssr?
                      proc { instance_exec(&`base.render_block`) }
                    else
                      given_block = block
                      proc do
                        %x{
                          let query = "[data-ssrhelper='" + #{self.class.to_s} + "']";
                          let el = document.querySelector(query);
                          if (el) { return { danger: true, html: el.innerHTML }; }
                          else { return #{instance_exec(&given_block)};
                          }
                        }
                      end
                    end
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
