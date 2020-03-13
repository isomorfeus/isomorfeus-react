module React
  module Component
    module Resolution
      def self.included(base)
        base.instance_exec do
          alias _react_component_class_resolution_original_const_missing const_missing

          def const_missing(const_name)
            %x{
              if (typeof Opal.global[const_name] !== "undefined" && (const_name[0] === const_name[0].toUpperCase())) {
                var new_const = #{React::NativeConstantWrapper.new(`Opal.global[const_name]`, const_name)};
                new_const.react_component = Opal.global[const_name];
                #{Object.const_set(const_name, `new_const`)};
                return new_const;
              } else {
                return #{_react_component_class_resolution_original_const_missing(const_name)};
              }
            }
          end

          # this is required for autoloading support, as the component may not be loaded and so its method is not registered.
          # must load it first, done by const_get, and next time the method will be there.
          unless method_defined?(:_react_component_class_resolution_original_method_missing)
            alias _react_component_class_resolution_original_method_missing method_missing
          end

          def method_missing(component_name, *args, &block)
            # check for ruby component and render it
            # otherwise pass on method missing
            %x{
              var constant;
              if (typeof self.iso_react_const_cache === 'undefined') { self.iso_react_const_cache = {}; }
              try {
                if (typeof self.iso_react_const_cache[component_name] !== 'undefined') {
                  constant = self.iso_react_const_cache[component_name]
                } else {
                  constant = self.$const_get(component_name);
                  self.iso_react_const_cache[component_name] = constant;
                }
                if (typeof constant.react_component !== 'undefined') {
                  return Opal.React.internal_prepare_args_and_render(constant.react_component, args, block);
                }
              } catch(err) { }
              return #{_react_component_class_resolution_original_method_missing(component_name, *args, block)};
            }
          end
        end
      end

      unless method_defined?(:_react_component_resolution_original_method_missing)
        alias _react_component_resolution_original_method_missing method_missing
      end

      def method_missing(component_name, *args, &block)
        # html tags are defined as methods, so they will not end up here.
        # first check for native component and render it, we want to be fast for native components
        # second check for ruby component and render it, they are a bit slower anyway
        # third pass on method missing
        %x{
          var constant;
          if (typeof self.iso_react_const_cache === 'undefined') { self.iso_react_const_cache = {}; }
          try {
            if (typeof self.iso_react_const_cache[component_name] !== 'undefined') {
              constant = self.iso_react_const_cache[component_name]
            } else if (typeof self.$$is_module !== 'undefined') {
              constant = self.$const_get(component_name);
              self.iso_react_const_cache[component_name] = constant;
            } else {
              constant = self.$class().$const_get(component_name);
              self.iso_react_const_cache[component_name] = constant;
            }
            if (typeof constant.react_component !== 'undefined') {
              return Opal.React.internal_prepare_args_and_render(constant.react_component, args, block);
            }
          } catch(err) { }
          return #{_react_component_resolution_original_method_missing(component_name, *args, block)};
        }
      end
    end
  end
end
