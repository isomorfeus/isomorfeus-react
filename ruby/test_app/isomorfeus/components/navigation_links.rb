class NavigationLinks < React::FunctionComponent::Base
  create_function do
    P do
      Link(to: '/') { 'Hello World!' }
      SPAN " | "
      Link(to: '/welcome') { 'Welcome!' }
    end
  end
end