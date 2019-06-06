class TestAppApp < LucidApp::Base
  render do
    Router do
      Switch do
        Route(path: '/', exact: true, component: HelloComponent.JS[:react_component])
        Route(path: '/ssr', exact: true, component: HelloComponent.JS[:react_component])
        Route(path: '/welcome', exact: true, component: WelcomeComponent.JS[:react_component])
        Route(path: '/material', exact: true, component: MaterialComponent.JS[:react_component])
        Route(path: '/function', exact: true, component: TestFunctionComponent.JS[:react_component])
        Route(path: '/memo', exact: true, component: TestMemoComponent.JS[:react_component])
      end
    end
  end
end