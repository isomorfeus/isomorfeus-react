module ExampleMaterial
  class Jogging < LucidMaterial::Component::Base
    render do
      (props.match.count.to_i).times do |i|
        SimplyMaterial(key: i, letter: 'a')
      end
      nil
    end
  end
end
