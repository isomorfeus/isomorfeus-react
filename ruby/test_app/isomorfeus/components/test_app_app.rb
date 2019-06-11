class TestAppApp < LucidMaterial::App::Base
  render do
    Router(location: props.location) do
      Switch do
        Route(path: '/', exact: true, component: HelloComponent.JS[:react_component])
        Route(path: '/ssr', exact: true, component: HelloComponent.JS[:react_component])
        Route(path: '/welcome', exact: true, component: WelcomeComponent.JS[:react_component])
      end
    end
  end
end