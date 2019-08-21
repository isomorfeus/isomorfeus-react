module LucidMaterial
  module Component
    module API
      def self.included(base)
        base.instance_exec do
          def styles(styles_hash = nil, &block)
            if block_given?
              %x{
                base.jss_styles = function(theme) {
                  var result = block.$call(Opal.Hash.$new(theme));
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
        end

        def classes
          props.classes
        end
      end
    end
  end
end
