module React
  module Component
    module Resolution
      def self.included(base)
        base.instance_exec do
          unless method_defined?(:_react_component_class_resolution_original_const_missing)
            alias _react_component_class_resolution_original_const_missing const_missing
          end

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
        # Further on it must check for modules, because $const_get does not take
        # the full nesting into account, as usually its called via $$ with the
        # nesting provided by the compiler.
        %x{
          var constant;
          if (typeof self.iso_react_const_cache === 'undefined') { self.iso_react_const_cache = {}; }

          if (typeof self.iso_react_const_cache[component_name] !== 'undefined') {
            constant = self.iso_react_const_cache[component_name]
          } else if (typeof self.$$is_a_module !== 'undefined') {
            try {
              constant = self.$const_get(component_name);
              self.iso_react_const_cache[component_name] = constant;
            } catch(err) { }
          } else {
            let sc = self.$class();
            try {
              constant = sc.$const_get(component_name);
              self.iso_react_const_cache[component_name] = constant;
            } catch(err) {
              var module_names = sc.$to_s().split("::");
              var module_name;
              for (var i = module_names.length - 1; i > 0; i--) {
                module_name = module_names.slice(0, i).join('::');
                try {
                  constant = sc.$const_get(module_name).$const_get(component_name, false);
                  self.iso_react_const_cache[component_name] = constant;
                  break;
                } catch(err) { }
              }
            }
          }
          if (constant && typeof constant.react_component !== 'undefined') {
            return Opal.React.internal_prepare_args_and_render(constant.react_component, args, block);
          }
          return #{_react_component_resolution_original_method_missing(component_name, *args, block)};
        }
      end
    end
  end
end
