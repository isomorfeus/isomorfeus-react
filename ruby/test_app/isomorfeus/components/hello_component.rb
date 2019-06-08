class HelloComponent < React::FunctionComponent::Base
  create_function do
    DIV "Hello World!"
    NavigationLinks()
  end
end