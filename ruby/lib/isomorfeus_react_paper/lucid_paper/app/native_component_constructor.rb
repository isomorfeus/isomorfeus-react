module LucidPaper
  module App
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        %x{
          base.jss_theme = Opal.global.Paper.DefaultTheme;
          base.themed_component = Opal.global.Paper.withTheme(base.lucid_react_component);
          base.react_component = class extends Opal.global.React.Component {
            constructor(props) {
              super(props);
              if (Opal.Isomorfeus.$top_component() == nil) { Opal.Isomorfeus['$top_component='](this); }
            }
            static get displayName() {
              return "IsomorfeusTopLevelComponent";
            }
            static set displayName(new_name) {
              // dont do anything here except returning the set value
              return new_name;
            }
            render() {
              let themed_component = Opal.global.React.createElement(base.themed_component, this.props);
              return Opal.global.React.createElement(Opal.global.Paper.Provider, { theme: base.jss_theme }, themed_component);
            }
          }
        }
      end
    end
  end
end
