module LucidMaterial
  module App
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s + 'Wrapper'
        theme_component_name = base.to_s + 'ThemeWrapper'
        # language=JS
        %x{
          base.jss_theme = Opal.global.Mui.createMuiTheme();
          base.themed_react_component = function(props) {
            let opag = Opal.global;
            let classes = null;
            let theme = opag.MuiStyles.useTheme();
            if (base.jss_styles) {
              if (!base.use_styles || (Opal.Isomorfeus.development === true)) {
                let styles;
                if (typeof base.jss_styles === 'function') { styles = base.jss_styles(theme); }
                else { styles = base.jss_styles; }
                base.use_styles = opag.MuiStyles.makeStyles(styles);
              }
              classes = base.use_styles();
            }
            let themed_classes_props = Object.assign({}, props, { classes: classes, theme: theme });
            return opag.React.createElement(base.lucid_react_component, themed_classes_props);
          }
          base.themed_react_component.displayName = #{theme_component_name};
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
              let themed_component = Opal.global.React.createElement(base.themed_react_component, this.props);
              return Opal.global.React.createElement(Opal.global.MuiStyles.ThemeProvider, { theme: base.jss_theme }, themed_component);
            }
          }
        }
      end
    end
  end
end
