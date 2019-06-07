module React
  module Component
    module Resolution
      def self.included(base)
        base.instance_exec do
          alias _react_component_resolution_original_const_missing const_missing

          def const_missing(const_name)
            # language=JS
            %x{
              if (typeof Opal.global[const_name] === "object") {
                var new_const = #{React::NativeConstantWrapper.new(`Opal.global[const_name]`, const_name)};
                #{Object.const_set(const_name, `new_const`)};
                return new_const;
              } else {
                return #{_react_component_resolution_original_const_missing(const_name)};
              }
            }
          end
        end
      end


      alias _react_component_resolution_original_method_missing method_missing

      def method_missing(component_name, *args, &block)
        # html tags are defined as methods, so they will not end up here.
        # first check for native component and render it, we want to be fast for native components
        # second check for ruby component and render it, they are a bit slower anyway
        # third pass on method missing
        # language=JS
        %x{
          var component = null;
          var component_type = typeof Opal.global[component_name];
          if (component_type === "function" || component_type === "object") {
            component = Opal.global[component_name];
          } else {
            var modules = self.$class().$to_s().split("::");
            var modules_length = modules.length - 1;
            var module;
            var constant;
            for (var i = modules_length; i > 0; i--) {
              try {
                module = modules.slice(0, i).join('::')
                constant = self.$class().$const_get(module).$const_get(component_name, false);
                if (typeof constant.react_component !== 'undefined') {
                  component = constant.react_component;
                  break;
                }
              } catch(err) {
                component = null;
              }
            }
            if (!component) {
              try {
                constant = Opal.Object.$const_get(component_name);
                if (typeof constant.react_component !== 'undefined') {
                  component = constant.react_component;
                }
              } catch(err) {
                component = null
              }
            }
          }
          if (component) {
            Opal.React.internal_prepare_args_and_render(component, args, block);
          } else {
            return #{_react_component_resolution_original_method_missing(component_name, *args, block)};
          }
        }
      end
    end
  end
end