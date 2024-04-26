class AllComponentTypesApp < React::Component::Base
  render do
    Router(location: props.location) do
      Switch do
        Route(path: '/fun_fun/:count', exact: true, component: ExampleFunction::Fun.JS[:react_component])
        Route(path: '/fun_run/:count', exact: true, component: ExampleFunction::Run.JS[:react_component])
        Route(path: '/com_fun/:count', exact: true, component: ExampleReact::Fun.JS[:react_component])
        Route(path: '/com_run/:count', exact: true, component: ExampleReact::Run.JS[:react_component])
        Route(path: '/js_fun/:count', exact: true, component: `global.ExampleJS.Fun`)
        Route(path: '/js_run/:count', exact: true, component: `global.ExampleJS.Run`)
        Route(path: '/all_the_fun/:count', exact: true, component: AllTheFun.JS[:react_component])
        Route(path: '/', strict: true, component: ShowLinks.JS[:react_component])
        Route(component: NotFound404Component.JS[:react_component])
      end
    end
  end
end
