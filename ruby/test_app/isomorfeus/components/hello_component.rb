class HelloComponent < LucidMaterial::Component::Base
  class_store.a_value = 'component class store works'
  store.a_value = 'component store works'
  app_store.a_value = 'application store works'
  render do
    DIV 'Rendered!'
    DIV "#{class_store.a_value}"
    DIV "#{store.a_value}"
    DIV "#{app_store.a_value}"
    NavigationLinks()
  end
end