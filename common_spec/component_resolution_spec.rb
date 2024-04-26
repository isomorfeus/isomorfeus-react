require 'spec_helper'

RSpec.describe 'Component Resolution' do
  before do
    @doc = visit('/')
    # create several kinds components, nested
    # resolution for React::Component
    # but we need to check in addition to one of the above React::FunctionComponent, which has the same resolution as the React::MemoComponent
    # and we need to check Native Components (see test_app, react.rb)
    # and we need to check resolution from element blocks
    @doc.evaluate_ruby do
      class TopPure < React::Component::Base
        render do
          DIV 'TopPure'
        end
      end

      module Deeply
        module Nested
          class Pure < React::Component::Base
            render do
              DIV 'Deeply::Nested::Pure'
            end
          end
        end
      end

      class TopFunction < React::FunctionComponent::Base
        render do
          DIV 'TopFunction'
        end
      end

      module VeryDeeply
        module VeryNested
          class VeryFunction < React::FunctionComponent::Base
            render do
              DIV 'VeryDeeply::VeryNested::VeryFunction'
            end
          end
        end
      end
    end

    @test_anchor = @doc.find('#test_anchor')
  end

  it 'can resolve components from a top level React::Component' do
    @doc.evaluate_ruby do
      class TestComponent < React::Component::Base
        render do
          TopPure()
          Deeply::Nested::Pure()
          TopFunction()
          VeryDeeply::VeryNested::VeryFunction()
          TopNativeComponent()
          NestedNative.AnotherComponent()
          NestedNative::AnotherComponent()
        end
      end

      React::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a nested React::Component' do
    @doc.evaluate_ruby do
      module Super
        module SuperDeeply
          module SuperNested
            class TestComponent < React::Component::Base
              render do
                TopPure()
                Deeply::Nested::Pure()
                TopFunction()
                VeryDeeply::VeryNested::VeryFunction()
                TopNativeComponent()
                NestedNative.AnotherComponent()
                NestedNative::AnotherComponent()
              end
            end
          end
        end
      end
      React::TopLevel.mount_component(Super::SuperDeeply::SuperNested::TestComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a top level React::Component DIV element' do
    @doc.evaluate_ruby do
      class TestComponent < React::Component::Base
        render do
          DIV do
            TopPure()
            Deeply::Nested::Pure()
            TopFunction()
            VeryDeeply::VeryNested::VeryFunction()
            TopNativeComponent()
            NestedNative.AnotherComponent()
            NestedNative::AnotherComponent()
          end
        end
      end

      React::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a nested React::Component DIV Element' do
    @doc.evaluate_ruby do
      module Super
        module SuperDeeply
          module SuperNested
            class TestComponent < React::Component::Base
              render do
                DIV do
                  TopPure()
                  Deeply::Nested::Pure()
                  TopFunction()
                  VeryDeeply::VeryNested::VeryFunction()
                  TopNativeComponent()
                  NestedNative.AnotherComponent()
                  NestedNative::AnotherComponent()
                end
              end
            end
          end
        end
      end
      React::TopLevel.mount_component(Super::SuperDeeply::SuperNested::TestComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a top level React::FunctionComponent' do
    @doc.evaluate_ruby do
      class TestComponent < React::FunctionComponent::Base
        render do
          TopPure()
          Deeply::Nested::Pure()
          TopFunction()
          VeryDeeply::VeryNested::VeryFunction()
          TopNativeComponent()
          NestedNative.AnotherComponent()
          NestedNative::AnotherComponent()
        end
      end

      React::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve components from a nested React::FunctionComponent' do
    @doc.evaluate_ruby do
      module Super
        module SuperDeeply
          module SuperNested
            class TestComponent < React::FunctionComponent::Base
              render do
                TopPure()
                Deeply::Nested::Pure()
                TopFunction()
                VeryDeeply::VeryNested::VeryFunction()
                TopNativeComponent()
                NestedNative.AnotherComponent()
                NestedNative::AnotherComponent()
              end
            end
          end
        end
      end
      React::TopLevel.mount_component(Super::SuperDeeply::SuperNested::TestComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('TopPure')
    expect(html).to include('Deeply::Nested::Pure')
    expect(html).to include('TopFunction')
    expect(html).to include('VeryDeeply::VeryNested::VeryFunction')
    expect(html).to include('TopNativeComponent')
    expect(html).to include('NestedNative.AnotherComponent')
  end

  it 'can resolve function components from within the same module' do
    @doc.evaluate_ruby do
      module ExampleFunction
        class AComponent < React::FunctionComponent::Base
          render do
            DIV "AComponent"
          end
        end
      end

      module ExampleFunction
        class AnotherComponent < React::FunctionComponent::Base
          render do
            DIV "AnotherComponent"
            AComponent()
          end
        end
      end
      React::TopLevel.mount_component(ExampleFunction::AnotherComponent, {}, '#test_anchor')
    end

    html = @test_anchor.html
    expect(html).to include('AnotherComponent')
    expect(html).to include('AComponent')
  end

  it "can resolve a ruby component in favor of a native component even when they have have the same name" do
    expect(@doc.html).to include('YetAnother::Switch rendered')
  end
end
