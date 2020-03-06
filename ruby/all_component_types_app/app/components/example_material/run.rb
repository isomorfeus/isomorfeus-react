module ExampleMaterial
  class Run < LucidMaterial::Component::Base
    render do
      (props.match.count.to_i / 12).times do |i|
        AnotherMaterialComponent(key: i)
      end
      nil
    end
  end
end
