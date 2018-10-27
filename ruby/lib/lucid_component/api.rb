module LucidComponent
  module API
    def self.included(base)
      base.instance_exec do
        def app_store
          @default_app_store_defined = true
          @default_app_store ||= ::React::ReduxComponent::AppStoreDefaults.new(default_props)
        end

        def class_store
          @default_class_store_defined = true
          @default_class_store ||= ::React::ReduxComponent::ComponentClassStoreDefaults.new(default_props, self.to_s)
        end

        def store
          @default_instance_store_defined = true
          @default_class_store ||= ::LucidComponent::ComponentInstanceStoreDefaults.new
        end

        def prop(name, options = `null`)
          name = `Opal.React.lower_camelize(name)`
          if options
            if options.has_key?(:default)
              %x{
                if (typeof self.lucid_react_component.defaultProps == "undefined") {
                  self.lucid_react_component.defaultProps = { isomorfeus_store: Opal.Hash.$new() };
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
          return @default_props if @default_props
          %x{
            if (typeof self.lucid_react_component.defaultProps == "undefined") {
              self.lucid_react_component.defaultProps = { isomorfeus_store: Opal.Hash.$new() };
            }
          }
          @default_props = React::Component::Props.new(`self.lucid_react_component.defaultProps`)
        end
      end
    end
  end
end
