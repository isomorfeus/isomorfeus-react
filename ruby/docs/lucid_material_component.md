### LucidMaterial::App andd LucidMaterial::Component
To use the MaterialUI support, it must be explicitly required in the opal code loader:
```ruby
require 'isomorfeus-react-material-ui'
```

LucidMaterial::App and LucidMaterial::Component works just like LucidApp and LucidComponent and provide in addition to them
support for styling.
```ruby
class MyApp < LucidMaterial::App::Base # is a React::Context provider
  render do
    Router do
      Switch do
        Route(path: '/', exact: true, component: MyComponent.JS[:react_component])
      end
    end
  end
end

class MyComponent < LucidMaterial::Component::Base # is a React::Context Consumer
  # styles can be set using a block that returns a hash:
  styles do
    {
      root: {
        width: 100,
        height: 100
      }
    } 
  end
  
  # or styles can be set using a hash argument:
  styles(root: { width: 100, height: 100 })
  
  render do
    # during render styles can be accessed with `classes`, just like in the MaterialUI documentation.
    DIV(class_name: classes.root) { 'Some text' }
  end
end
```

The lifecycle callbacks starting with `unsafe_` are not supported.
Overwriting should_component_update is also not supported.

**Data flow of a LucidMaterial::Component within a LucidMaterial::App:**
![LucidComponent within a LucidApp Data Flow](https://raw.githubusercontent.com/isomorfeus/isomorfeus-react/master/images/data_flow_lucid_component.png)
