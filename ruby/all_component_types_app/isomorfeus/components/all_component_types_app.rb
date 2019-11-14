class AllComponentTypesApp < LucidMaterial::App::Base
  render do
    Router(location: props.location) do
      Switch do
        Route(path: '/fun_fun/:count', exact: true, component: ExampleFunction::Fun.JS[:react_component])
        Route(path: '/fun_run/:count', exact: true, component: ExampleFunction::Run.JS[:react_component])
        Route(path: '/com_fun/:count', exact: true, component: ExampleReact::Fun.JS[:react_component])
        Route(path: '/com_run/:count', exact: true, component: ExampleReact::Run.JS[:react_component])
        Route(path: '/luc_fun/:count', exact: true, component: ExampleLucid::Fun.JS[:react_component])
        Route(path: '/luc_run/:count', exact: true, component: ExampleLucid::Run.JS[:react_component])
        Route(path: '/func_fun/:count', exact: true, component: ExampleLucidFunc::Fun.JS[:react_component])
        Route(path: '/func_run/:count', exact: true, component: ExampleLucidFunc::Run.JS[:react_component])
        Route(path: '/lucs_fun/:count', exact: true, component: ExampleLucid::Jogging.JS[:react_component])
        Route(path: '/lucs_run/:count', exact: true, component: ExampleLucid::Jogging.JS[:react_component])
        Route(path: '/lucsy_fun/:count', exact: true, component: ExampleLucidSyntax::Fun.JS[:react_component])
        Route(path: '/lucsy_run/:count', exact: true, component: ExampleLucidSyntax::Run.JS[:react_component])
        Route(path: '/lucssy_fun/:count', exact: true, component: ExampleLucidSyntax::Jogging.JS[:react_component])
        Route(path: '/lucssy_run/:count', exact: true, component: ExampleLucidSyntax::Jogging.JS[:react_component])
        Route(path: '/mat_fun/:count', exact: true, component: ExampleMaterial::Fun.JS[:react_component])
        Route(path: '/mat_run/:count', exact: true, component: ExampleMaterial::Run.JS[:react_component])
        Route(path: '/mats_fun/:count', exact: true, component: ExampleMaterial::Jogging.JS[:react_component])
        Route(path: '/mats_run/:count', exact: true, component: ExampleMaterial::Jogging.JS[:react_component])
        Route(path: '/js_fun/:count', exact: true, component: `global.ExampleJS.Fun`)
        Route(path: '/js_run/:count', exact: true, component: `global.ExampleJS.Run`)
        Route(path: '/all_the_fun/:count', exact: true, component: AllTheFun.JS[:react_component])
        Route(path: '/', strict: true, component: ShowLinks.JS[:react_component])
        Route(component: NotFound404Component.JS[:react_component])
      end
    end
  end
end
