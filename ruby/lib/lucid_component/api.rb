module LucidComponent
  module API
    def self.included(base)
      base.instance_exec do
        def prop(name, options = `null`)
          name = `Opal.React.lower_camelize(name)`
          if options
            if options.has_key?(:default)
              %x{
                if (typeof self.lucid_react_component.defaultProps == "undefined") {
                  self.lucid_react_component.defaultProps = {};
                }
                self.lucid_react_component.defaultProps[name] = options.$fetch("default");
              }
            end
            if options.has_key?(:class)
              %x{
                if (typeof self.lucid_react_component.propTypes == "undefined") {
                  self.lucid_react_component.propTypes = {};
                  self.lucid_react_component.propValidations = {};
                  self.lucid_react_component.propValidations[name] = {};
                }
                self.lucid_react_component.propTypes[name] = self.lucid_react_component.prototype.validateProp;
                self.lucid_react_component.propValidations[name].ruby_class = options.$fetch("class");
              }
            elsif options.has_key?(:is_a)
              %x{
                if (typeof self.lucid_react_component.propTypes == "undefined") {
                  self.lucid_react_component.propTypes = {};
                  self.lucid_react_component.propValidations = {};
                  self.lucid_react_component.propValidations[name] = {};
                }
                self.lucid_react_component.propTypes[name] = self.lucid_react_component.prototype.validateProp;
                self.lucid_react_component.propValidations[name].is_a = options.$fetch("is_a");
              }
            end
            if options.has_key?(:required)
              %x{
                if (typeof self.lucid_react_component.propTypes == "undefined") {
                  self.lucid_react_component.propTypes = {};
                  self.lucid_react_component.propValidations = {};
                  self.lucid_react_component.propValidations[name] = {};
                }
                self.lucid_react_component.propTypes[name] = self.lucid_react_component.prototype.validateProp;
                self.lucid_react_component.propValidations[name].required = options.$fetch("required");
              }
            elsif !options.has_key?(:default)
              %x{
                if (typeof self.lucid_react_component.propTypes == "undefined") {
                  self.lucid_react_component.propTypes = {};
                  self.lucid_react_component.propValidations = {};
                }
                self.lucid_react_component.propTypes[name] = self.lucid_react_component.prototype.validateProp;
                self.lucid_react_component.propValidations[name].required = true;
              }
            end
          else
            %x{
              if (typeof self.lucid_react_component.propTypes == "undefined") {
                self.lucid_react_component.propTypes = {};
                self.lucid_react_component.propValidations = {};
                self.lucid_react_component.propValidations[name] = {};
              }
              self.lucid_react_component.propTypes[name] = self.lucid_react_component.prototype.validateProp;
              self.lucid_react_component.propValidations[name].required = options.$fetch("required");
            }
          end
        end

        def default_props
          React::Component::Props.new(`self.lucid_react_component.prototype.defaultProps`)
        end
      end
    end
  end
end
