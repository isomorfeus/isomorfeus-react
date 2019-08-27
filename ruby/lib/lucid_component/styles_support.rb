module LucidComponent
  module StylesSupport
    def self.included(base)
      base.instance_exec do
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
      end

      def styles
        props.classes
      end

      def theme
        props.theme
      end
    end
  end
end

