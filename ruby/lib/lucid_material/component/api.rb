module LucidMaterial
  module Component
    module API
      def self.included(base)
        base.instance_exec do
          def styles(styles_hash = nil, &block)
            styles_hash = block.call if block_given?
            `base.jss_styles = #{styles_hash.to_n}` if styles_hash
            `Opal.Hash.$new(base.jss_styles)`
          end
        end

        def classes
          props.classes
        end
      end
    end
  end
end
