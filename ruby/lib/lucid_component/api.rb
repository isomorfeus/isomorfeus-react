module LucidComponent
  module API
    def self.included(base)
      base.instance_exec do
        def prop(name, options = `null`)
          name = `Opal.React.lower_camelize(name)`
          if options
            if options.key?(:default)
              %x{
                if (typeof self.lucid_react_component.defaultProps == "undefined") {
                  self.lucid_react_component.defaultProps = { isomorfeus_store: Opal.Hash.$new() };
                }
                self.lucid_react_component.defaultProps[name] = options.$fetch("default");
              }
            end
            if options.key?(:class)
              %x{
                if (typeof self.lucid_react_component.propTypes == "undefined") {
                  self.lucid_react_component.propTypes = {};
                  self.lucid_react_component.propValidations = {};
                  self.lucid_react_component.propValidations[name] = {};
                }
                self.lucid_react_component.propTypes[name] = self.lucid_react_component.prototype.validateProp;
                self.lucid_react_component.propValidations[name].ruby_class = options.$fetch("class");
              }
            elsif options.key?(:is_a)
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
            if options.key?(:required)
              %x{
                if (typeof self.lucid_react_component.propTypes == "undefined") {
                  self.lucid_react_component.propTypes = {};
                  self.lucid_react_component.propValidations = {};
                  self.lucid_react_component.propValidations[name] = {};
                }
                self.lucid_react_component.propTypes[name] = self.lucid_react_component.prototype.validateProp;
                self.lucid_react_component.propValidations[name].required = options.$fetch("required");
              }
            elsif !options.key?(:default)
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
          return @default_props if @default_props
          %x{
            if (typeof self.lucid_react_component.defaultProps == "undefined") {
              self.lucid_react_component.defaultProps = { isomorfeus_store: Opal.Hash.$new() };
            }
          }
          @default_props = React::Component::Props.new(`{props: self.lucid_react_component.defaultProps}`)
        end
      end
    end
  end
end
