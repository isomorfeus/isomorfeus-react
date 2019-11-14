module ExampleLucidFunc
  class Fun < LucidFunc::Base
    render do
      props.match.count.to_i.times do |i|
        ExampleLucidFunc::AnotherFuncComponent(key: i)
      end
      nil
    end
  end
end
