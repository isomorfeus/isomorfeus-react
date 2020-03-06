module ExampleLucid
  class Fun < LucidComponent::Base
    render do
      props.match.count.to_i.times do |i|
        AnotherLucidComponent(key: i)
      end
      nil
    end
  end
end
