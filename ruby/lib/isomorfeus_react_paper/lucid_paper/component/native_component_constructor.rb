module LucidPaper
  module Component
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s + 'Wrapper'
        # language=JS
        %x{
          base.react_component = Opal.global.React.memo(function(props) {
            let classes = null;
            let store;
            if (base.store_updates) { store = Opal.global.React.useContext(Opal.global.LucidApplicationContext); }
            let new_props = Object.assign({}, props)
            new_props.store = store;
            new_props.theme = Opal.global.Paper.useTheme();
            return Opal.global.React.createElement(base.lucid_react_component, new_props);
          }, Opal.React.props_are_equal);
          base.react_component.displayName = #{component_name};
        }
      end
    end
  end
end
