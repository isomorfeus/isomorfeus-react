module React
  module FunctionComponent
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
          }
          else {
            try {
              var constant = self.$class().$const_get(component_name, true);
              component_type = typeof constant.react_component;
              if (component_type === "function" || component_type === "object") {
                component = constant.react_component;
              }
            }
            catch(err) {
              component = null;
            }
          }
          if (component) {
            if (args.length > 0) {
              var last_arg = args[args.length - 1];
              if (typeof last_arg === 'string' || last_arg instanceof String) {
                if (args.length === 1) { Opal.React.internal_render(component, null, last_arg, null); }
                else { Opal.React.internal_render(component, args[0], last_arg, null); }
              } else { Opal.React.internal_render(component, args[0], null, block); }
            } else { Opal.React.internal_render(component, null, null, block); }
          } else {
            return #{_react_component_resolution_original_method_missing(component_name, *args, block)};
          }
        }
      end

    end
  end
end