class Page404Component < React::Component::Base
  render do
    React.ssr_response_status = 404
    P "Oops, page not found!"
    NavigationLinks()
  end
end
