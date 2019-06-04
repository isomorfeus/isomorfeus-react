class NavigationLinks < LucidComponent::Base
  render do
    P do
      Link(to: '/') { 'Hello World!' }
      SPAN " | "
      Link(to: '/welcome') { 'Welcome!' }
    end
  end
end