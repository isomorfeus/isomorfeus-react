class WelcomeComponent < LucidComponent::Base
  render do
    DIV "Welcome!"
    NavigationLinks()
  end
end