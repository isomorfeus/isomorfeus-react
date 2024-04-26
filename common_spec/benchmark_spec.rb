require 'spec_helper'

RSpec.describe 'Component benchmarks' do
  it 'Load Time' do
    doc = visit('/')
    doc.wait_for('#test_anchor')
    react_lt, react_rt, app_lt = doc.evaluate_ruby do
      [IR_LOAD_TIME, IR_REACT_REQUIRE_TIME, APP_LOAD_TIME]
    end
    puts "opal load time: #{app_lt - (react_rt + react_lt)}ms"
    puts "isomorfeus-react require time: #{react_rt}ms"
    puts "isomorfeus-react start_app! time: #{react_lt}ms"
    puts "application load_time: #{app_lt}ms"
    expect(app_lt < 500).to be true
  end

  it 'Native DIV Element' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            result = []
            10000.times do
              result << `Opal.global.React.createElement('div', null, 'A')`
            end
            result
          end
        end
      end

      start = Time.now
      React::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Native DIV Elements took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'DIV Element (String param)' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              DIV "A"
            end
          end
        end
      end

      start = Time.now
      React::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 DIV Elements (String param) took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'DIV Element (String block)' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              DIV { "A" }
            end
          end
        end
      end

      start = Time.now
      React::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 DIV Elements (String block) took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Native Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              NativeComponent()
            end
          end
        end
      end

      start = Time.now
      React::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Native Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Function Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Fun < React::FunctionComponent::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              Fun()
            end
          end
        end
      end

      start = Time.now
      React::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Function Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Memo Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Memo < React::MemoComponent::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              Memo()
            end
          end
        end
      end

      start = Time.now
      React::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Memo Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'React Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Pure < React::Component::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              Pure()
            end
          end
        end
      end

      start = Time.now
      React::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 React Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end
end
