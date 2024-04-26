class NotFound404Component < React::Component::Base
  render do
    React.ssr_response_status = 404 # keep
    P "Oops, page not found!"
    NavigationLinks()
  end
end