require 'spec_helper'

RSpec.describe 'Component benchmarks' do
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
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Native DIV Elements took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'DIV Element' do
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
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 DIV Elements took: #{time}ms"
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
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Native Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Function Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Fun < React::FunctionComponent::Base
        create_function do
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
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Function Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Memo Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Memo < React::MemoComponent::Base
        create_memo do
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
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Memo Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Pure Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Pure < React::PureComponent::Base
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
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Pure Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Component' do
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
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Redux Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class ReduxC < React::ReduxComponent::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < React::Component::Base
        render do
          Fragment do
            10000.times do
              ReduxC()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Redux Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Lucid Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidComponent::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < LucidApp::Base
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Lucid Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end

  it 'Lucid Material Component' do
    doc = visit('/')
    time = doc.evaluate_ruby do
      class Lucy < LucidMaterial::Component::Base
        render do
          DIV 'A'
        end
      end
      class BenchmarkComponent < LucidMaterial::App::Base
        render do
          Fragment do
            10000.times do
              Lucy()
            end
          end
        end
      end

      start = Time.now
      Isomorfeus::TopLevel.mount_component(BenchmarkComponent, {}, '#test_anchor')
      (Time.now - start) * 1000
    end
    puts "10000 Lucid Material Components took: #{time}ms"
    expect(time > 0 && time < 1000).to be_truthy
  end
end