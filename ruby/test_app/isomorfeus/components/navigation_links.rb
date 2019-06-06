class NavigationLinks < LucidComponent::Base
  render do
    P do
      Link(to: '/') { 'Hello World!' }
      SPAN " | "
      Link(to: '/welcome') { 'Welcome!' }
      SPAN " | "
      Link(to: '/material') { 'Material' }
      SPAN " | "
      Link(to: '/function') { 'Function' }
      SPAN " | "
      Link(to: '/memo') { 'Memo' }
    end
  end
end