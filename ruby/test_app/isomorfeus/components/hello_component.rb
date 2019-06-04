class HelloComponent < LucidComponent::Base
  render do
    DIV "Hello World!"
    NavigationLinks()
  end
end