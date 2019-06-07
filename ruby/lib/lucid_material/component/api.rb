module LucidMaterial
  module Component
    module API
      def self.included(base)
        base.instance_exec do
          def styles=(styles_hash)
            styles(styles_hash)
          end

          def styles(styles_hash = nil, &block)
            new_styles = block_given? ? block.call : styles_hash
            if new_styles
              `base.jss_styles = #{new_styles.to_n}`
            end
          end
        end

        def classes
          props.classes
        end
      end
    end
  end
end
