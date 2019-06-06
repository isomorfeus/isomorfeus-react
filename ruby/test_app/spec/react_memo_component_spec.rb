require 'spec_helper'

RSpec.describe 'React::MemoComponent' do

  # React.memo as of React 16.8 does not return anything, so it cant be used as top level component,
  # React complains that it returns nothing. So we use a wrapper component.

  it 'can render a component that is using inheritance' do
    doc = visit('/')
    doc.evaluate_ruby do
      class TestComponent < React::MemoComponent::Base
        create_memo do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      class Wrapper < React::Component::Base
        render do
          TestComponent()
        end
      end
      Isomorfeus::TopLevel.mount_component(Wrapper, {}, '#test_anchor')
    end
    node = doc.wait_for('#test_component')
    expect(node.all_text).to include('TestComponent rendered')
  end

  it 'can render a component that is using the mixin' do
    doc = visit('/')
    doc.evaluate_ruby do
      class TestComponent
        include React::MemoComponent::Mixin
        create_memo do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      class Wrapper
        include React::Component::Mixin
        render do
          TestComponent()
        end
      end
      Isomorfeus::TopLevel.mount_component(Wrapper, {}, '#test_anchor')
    end
    node = doc.wait_for('#test_component')
    expect(node.all_text).to include('TestComponent rendered')
  end
end
