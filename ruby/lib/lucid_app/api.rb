module LucidApp
  module API
    def self.included(base)
      base.instance_exec do
        def theme(theme_hash = nil, &block)
          if block_given?
            %x{
              let result = block.$call();
              base.jss_theme = result.$to_n();
              return result;
            }
          elsif theme_hash
            `base.jss_theme = #{theme_hash.to_n}` if theme_hash
            theme_hash
          elsif `typeof base.jss_theme === 'object'`
            `Opal.Hash.$new(base.jss_theme)`
          else
            nil
          end
        end
        alias_method :theme=, :theme
      end

      def context
        @native.JS[:context]
      end
    end
  end
end
