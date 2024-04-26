module React
  class Component
    class Props
      module Declaration
        if RUBY_ENGINE == 'opal'
          def self.extended(base)
            def prop(prop_name, validate_hash = { required: true })
              validate_hash = validate_hash.to_h if validate_hash.class == React::Component::Props::ValidateHashProxy
              if validate_hash.key?(:default)
                %x{
                  if (base.react_component) {
                    let react_prop_name = Opal.React.lower_camelize(prop_name);
                    #{value = validate_hash[:default]}
                    if (!base.react_component.defaultProps) { base.react_component.defaultProps = {}; }
                    base.react_component.defaultProps[react_prop_name] = value;
                    if (!base.react_component.propTypes) { base.react_component.propTypes = {}; }
                    base.react_component.propTypes[react_prop_name] = base.react_component.prototype.validateProp;
                  }
                }
              end
              declared_props[prop_name.to_sym] = validate_hash
            end
          end

          def validate_function
            %x{
              if (typeof self.validate_function === 'undefined') {
                self.validate_function = function(props_object) {
                  try { self.$validate_props(Opal.Hash.$new(props_object)) }
                  catch (e) { return e.message; }
                }
              }
              return self.validate_function;
            }
          end

          def validate_prop_function(prop)
            function_name = "validate_#{prop}_function"
            %x{
              if (typeof self[function_name] === 'undefined') {
                self[function_name] = function(value) {
                  try { self.$validate_prop(prop, value); }
                  catch (e) { return e.message; }
                }
              }
              return self[function_name];
            }
          end
        else
          def prop(prop_name, validate_hash = { required: true })
            validate_hash = validate_hash.to_h if validate_hash.class == React::Component::Props::ValidateHashProxy
            declared_props[prop_name.to_sym] = validate_hash
          end
        end

        def declared_props
          @declared_props ||= {}
        end

        def valid_prop?(prop, value)
          validate_prop(prop, value)
        rescue
          false
        end

        def valid_props?(props)
          validate_props(props)
        rescue
          false
        end

        def validate
          React::Component::Props::ValidateHashProxy.new
        end

        def validate_prop(prop, value)
          return false unless declared_props.key?(prop)
          validator = React::Component::Props::Validator.new(self, prop, value, declared_props[prop])
          validator.validate!
          true
        end

        def validate_props(props)
          props = {} unless props
          declared_props.each_key do |prop|
            if declared_props[prop].key?(:required) && declared_props[prop][:required] && !props.key?(prop)
              React.raise_error(message: "Required prop #{prop} not given!")
            end
          end
          result = true
          props.each do |p, v|
            r = validate_prop(p, v)
            result = false unless r
          end
          result
        end

        def validated_prop(prop, value)
          React.raise_error(message: "No such prop #{prop} declared!") unless declared_props.key?(prop)
          validator = React::Component::Props::Validator.new(self, prop, value, declared_props[prop])
          validator.validated_value
        end

        def validated_props(props)
          props = {} unless props

          declared_props.each_key do |prop|
            if declared_props[prop].key?(:required) && declared_props[prop][:required] && !props.key?(prop)
              React.raise_error(message: "Required prop #{prop} not given!")
            end
            props[prop] = nil unless props.key?(prop) # let validator handle value
          end

          result = {}
          props.each do |p, v|
            result[p] = validated_prop(p, v)
          end
          result
        end
      end
    end
  end
end
