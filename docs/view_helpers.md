### View helpers
The view helpers module can be included in any class:
```ruby
class MyClass
  include React::ReactViewHelpers
end
```

The following view helpers are available:

- `mount_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the hydrated html tree for consumption
 by React on the client
- `cached_mount_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the hydrated html tree for consumption
 by React on the client. The tree is cached so the component code is executed only once.
- `mount_static_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the rendered html tree as static html
 string. The result cannot be used by React on the client.
- `cached_mount_static_component(component_class_name, component_props, ssr_asset)` - mounts a component and returns the rendered html tree as static html
 string. The result cannot be used by React on the client. The tree is cached so the component code is executed only once.
- `ssr_response_status` - returns the HTTP response status as returned by the last execution of any of the above mount helpers.
