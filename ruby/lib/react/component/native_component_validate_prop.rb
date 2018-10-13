module React
  module Component
    module NativeComponentValidateProp
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        # language=JS
        %x{
          base.react_component.prototype.validateProp = function(props, propName, componentName) {
            var prop_data = base.react_component.propValidations[propName];
            if (!prop_data) { return true; };
            var value = props[propName];
            var result;
            if (typeof prop_data.ruby_class != "undefined") {
              result = (value.$class() == prop_data.ruby_class);
              if (!result) {
                return new Error('Invalid prop ' + propName + '! Expected ' + prop_data.ruby_class.$to_s() + ' but was ' + value.$class().$to_s() + '!');
              }
            } else if (typeof prop_data.is_a != "undefined") {
              result = value["$is_a?"](prop_data.is_a);
              if (!result) {
                return new Error('Invalid prop ' + propName + '! Expected a child of ' + prop_data.is_a.$to_s() + '!');
              }
            }
            if (typeof prop_data.required != "undefined") {
              if (prop_data.required && (typeof props[propName] == "undefined")) {
                return new Error('Prop ' + propName + ' is required but not given!');
              }
            }
            return null;
          }
        }
      end
    end
  end
end
