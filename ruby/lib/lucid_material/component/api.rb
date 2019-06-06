module LucidMaterial
  module Component
    module API
      def styles
        @component_styles ||= {}
      end

      def add_styles(style_hash = {}, &block)
        new_styles = block_given? ? block.call : style_hash
        # TODO deep_merge
        styles.merge!(new_styles)
      end
    end
  end
end
