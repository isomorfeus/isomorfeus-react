class AFunctionComponent < React::FunctionComponent::Base
  event_handler do
    puts 'test'
  end
  create_function do
    DIV 'test'
  end
end

class TestFunctionComponent < React::Component::Base
  render do
    AFunctionComponent()
  end
end