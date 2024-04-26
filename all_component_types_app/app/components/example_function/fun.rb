module ExampleFunction
  class Fun < React::FunctionComponent::Base
    render do
      props.match.count.to_i.times do |i|
        ExampleFunction::AnotherFunComponent(key: i)
      end
      nil
    end
  end
end
