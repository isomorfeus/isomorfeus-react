module LucidComponent
  module ReactNativeComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s + 'Wrapper'
      # language=JS
      %x{
        base.react_component = Opal.global.React.memo(function(props) {
          let opag = Opal.global;
          let store;
          if (base.store_updates) { store = opag.React.useContext(opag.LucidApplicationContext); }
          const theme = opag.React.useContext(opag.ThemeContext);
          let classes;
          if (base.jss_styles) {
            if (!base.use_styles || (Opal.Isomorfeus.development === true)) {
              let styles;
              if (typeof base.jss_styles === 'function') { styles = base.jss_styles(theme); }
              else { styles = base.jss_styles; }
              base.use_styles = Opal.React.merge_deep(theme, opag.StyleSheet.create(styles));
            }
            classes = base.use_styles;
          } else {
            classes = theme;
          }
          let new_props = Object.assign({}, props);
          new_props.theme = theme;
          new_props.classes = classes;
          new_props.store = store;
          return opag.React.createElement(base.lucid_react_component, new_props);
        }, Opal.React.props_are_equal);
        base.react_component.displayName = #{component_name};
      }
    end
  end
end
