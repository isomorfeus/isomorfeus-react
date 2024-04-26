class AllTheFun < React::Component::Base
  render do
    DIV { ExampleFunction::AnotherFunComponent() }
    DIV { ExampleReact::AnotherComponent() }
    DIV { ExampleJS.AnotherComponent() }
  end
end
