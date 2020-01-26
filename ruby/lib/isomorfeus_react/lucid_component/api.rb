module LucidComponent
  module Api
    def self.included(base)
      base.instance_exec do
        # store
        attr_accessor :app_store
        attr_accessor :class_store
        attr_accessor :store

        def default_app_store_defined
          @default_app_store_defined
        end

        def default_class_store_defined
          @default_class_store_defined
        end

        def default_instance_store_defined
          @default_instance_store_defined
        end

        def app_store
          @default_app_store_defined = true
          @default_app_store ||= ::LucidComponent::AppStoreDefaults.new(state, self.to_s)
        end

        def class_store
          @default_class_store_defined = true
          @default_class_store ||= ::LucidComponent::ComponentClassStoreDefaults.new(state, self.to_s)
        end

        def store
          @default_instance_store_defined = true
          @default_instance_store ||= ::LucidComponent::ComponentInstanceStoreDefaults.new(state, self.to_s)
        end

        def store_updates(switch)
          case switch
          when :on then `base.store_updates = true`
          when :off then `base.store_updates = false`
          end
        end

        # styles
        def styles(styles_hash = nil, &block)
          if block_given?
            %x{
              base.jss_styles = function(theme) {
                let wrapped_theme = Opal.React.Component.Styles.$new(theme);
                var result = block.$call(wrapped_theme);
                return result.$to_n();
              }
            }
            nil
          elsif styles_hash
            `base.jss_styles = #{styles_hash.to_n}` if styles_hash
            styles_hash
          elsif `typeof base.jss_styles === 'object'`
            `Opal.Hash.$new(base.jss_styles)`
          else
            nil
          end
        end
        alias_method :styles=, :styles

        # preloading
        def preload(&block)
          `base.preload_block = block`
          component_did_mount do
            unless self.state.preloaded
              @_preload_promise.then { self.state.preloaded = true }.fail do |result|
                err_text = "#{self.class.name}: preloading failed, last result: #{result.nil? ? 'nil' : result}!"
                `console.error(err_text)`
              end
            end
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

      # styles
      def styles
        props.classes
      end

      def theme
        props.theme
      end

      # preloading
      def execute_preload_block
        @_preload_promise = instance_exec(&self.class.JS[:preload_block])
        @_preload_promise.resolved?
      end

      def preloaded?
        !!state.preloaded
      end

      # requires transport
      def current_user
        Isomorfeus.current_user
      end
    end
  end
end
