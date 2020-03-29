### LucidPaper::App andd LucidPaper::Component
To use the React Native and Web Paper support, it must be explicitly required in the opal code loader:
```ruby
require 'isomorfeus-react-paper'
```
Also the Paper imports must be present, see the installation.md doc.

LucidPaper::App and LucidPaper::Component works just like LucidApp and LucidComponent but provide only subset of styling options
to suit both, ReactNative and Web, equally.
```ruby
class MyApp < LucidPaper::App::Base # is a React::Context provider
  # LucidPaper::App can provide a styles theme, it can be referred to by the LucidPaper::Component theme method, see below
  theme do |default_theme|
    default_theme.deep_merge!({ master: { width: 200 }})
  end

  render do
    Router do
      Switch do
        Route(path: '/', exact: true, component: MyComponent.JS[:react_component])
      end
    end
  end
end

class MyComponent < LucidPaper::Component::Base # is a React::Context Consumer

  render do
    # during render the theme can be accessed with `theme`:
    DIV(style: theme.master) { 'Some text' }
    # the theme from LucidPaper::App can be accessed also like this:
    DIV(style: { width: theme.master.width }) { 'Some text' }
  end
end
```

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a LucidPaper::Component within a LucidPaper::App:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_lucid_component.png)
