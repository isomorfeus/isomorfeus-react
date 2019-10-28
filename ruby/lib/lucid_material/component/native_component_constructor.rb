module LucidMaterial
  module Component
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s + 'Wrapper'
        # language=JS
        %x{
          base.react_component = function(props) {
            let classes = null;
            let store;
            if (base.store_updates) { store = Opal.global.React.useContext(Opal.global.LucidApplicationContext); }
            let theme = Opal.global.MuiStyles.useTheme();
            if (base.jss_styles) {
              if (!base.use_styles || (Opal.Isomorfeus.development && Opal.Isomorfeus.development !== nil)) {
                let styles;
                if (typeof base.jss_styles === 'function') { styles = base.jss_styles(theme); }
                else { styles = base.jss_styles; }
                base.use_styles = Opal.global.MuiStyles.makeStyles(styles);
              }
              classes = base.use_styles();
            }
            let new_props = Object.assign({}, props)
            new_props.classes = classes;
            new_props.theme = theme;
            new_props.store = store;
            return Opal.global.React.createElement(base.lucid_react_component, new_props);
          }
          base.react_component.displayName = #{component_name};
        }
      end
    end
  end
end
