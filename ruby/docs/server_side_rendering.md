### Server Side Rendering
SSR is turned on by default in production and turned of in development. SSR is done in node using isomorfeus-speednode.
Components that depend on a browser can be shielded from rendering in node by using the above execution environment helper methods.
Example:
```ruby
class MyOtherComponent < React::Component::Base

  render do
    if Isomorfeus.on_browser?
      SomeComponentDependingOnWindow()
    else
      DIV()
    end
  end
end
```
