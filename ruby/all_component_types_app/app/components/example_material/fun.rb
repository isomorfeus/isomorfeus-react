module ExampleMaterial
  class Fun < LucidMaterial::Component::Base
    render do
      props.match.count.to_i.times do |i|
        AnotherMaterialComponent(key: i)
      end
      nil
    end
  end
end
