require 'spec_helper'

RSpec.describe 'LucidPaper::Func' do
  it 'can render a component that is using inheritance' do
    doc = visit('/')
    doc.evaluate_ruby do
      class TestComponent < LucidPaper::Func::Base
        render do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    node = doc.wait_for('#test_component')
    expect(node.all_text).to include('TestComponent rendered')
  end

  it 'can render a component that is using the mixin' do
    doc = visit('/')
    doc.evaluate_ruby do
      class TestComponent
        include LucidPaper::Func::Mixin
        render do
          DIV(id: :test_component) { 'TestComponent rendered' }
        end
      end
      Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
    end
    node = doc.wait_for('#test_component')
    expect(node.all_text).to include('TestComponent rendered')
  end

  context 'it accepts props and can' do
    before do
      @doc = visit('/')
    end

    it 'access them' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          render do
            DIV(id: :test_component) do
              SPAN props.text
              SPAN props.other_text
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { text: 'Prop passed!', other_text: 'Passed other prop!' }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      all_text = node.all_text
      expect(all_text).to include('Prop passed!')
      expect(all_text).to include('Passed other prop!')
    end

    it 'accept a missing prop' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
    end
  end

  context 'it can handle events like' do
    before do
      @doc = visit('/')
    end

    it 'on_click' do
      @doc.evaluate_ruby do
        IT = { clicked: false }
        class TestComponent < LucidPaper::Func::Base
          def change_hash(event)
            IT[:clicked] = true
          end
          render do
            DIV(id: :test_component, on_click: :change_hash) { 'nothinghere' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      node.click
      result = @doc.evaluate_ruby do
        IT[:clicked]
      end
      expect(result).to be true
    end
  end

  context 'it has hooks like' do
    before do
      @doc = visit('/')
    end

    it 'use_state' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          render do
            value, set_value = use_state('nothinghere')
            handler = proc { |event| set_value.call('somethinghere') }
            DIV(id: :test_component, on_click: handler) { value }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      node.click
      expect(node.all_text).to include('somethinghere')
    end
  end

  context 'it has a component store and can' do
    # LucidComponent MUST be used within a LucidApp for things to work

    before do
      @doc = visit('/')
    end

    it 'use a uninitialized store value and change it' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          def change_state(event)
            store.something = true
          end
          render do
            if store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{store.something}here" }
            end
          end
        end
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('true')
    end
  end

  context 'it has a component class_store and can' do
    # LucidComponent MUST be used within a LucidApp for things to work

    before do
      @doc = visit('/')
    end

    it 'define a default class_store value and access it' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          render do
            DIV(id: :test_component) { class_store.something }
          end
        end
        TestComponent.class_store.something = 'Something state intialized!'
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('Something state intialized!')
    end

    it 'define a default class_store value and change it' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          def change_state(event)
            class_store.something = false
          end
          render do
            if class_store.something
              DIV(id: :test_component, on_click: :change_state) { "#{class_store.something}" }
            else
              DIV(id: :changed_component, on_click: :change_state) { "#{class_store.something}" }
            end
          end
        end
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
      end
      @doc.evaluate_ruby do
        TestComponent.class_store.something = true
      end
      @doc.evaluate_ruby do
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('true')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('false')
    end

    it 'use a uninitialized store value and change it' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          def change_state(event)
            class_store.something = true
          end
          render do
            if class_store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{class_store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{class_store.something}here" }
            end
          end
        end
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('true')
    end
  end

  context 'it has a app_store and can' do
    # LucidComponent MUST be used within a LucidApp for things to work

    before do
      @doc = visit('/')
    end

    it 'define a default app_store value and access it' do
      @doc.evaluate_ruby do
        AppStore.something = 'Something state intialized!'
      end
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          render do
            DIV(id: :test_component) { app_store.something }
          end
        end
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('Something state intialized!')
    end

    it 'define a default app_store value and change it' do
      @doc.evaluate_ruby do
        AppStore.something = true
      end
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          def change_state(event)
            app_store.something = false
          end
          render do
            if app_store.something
              DIV(id: :test_component, on_click: :change_state) { "#{app_store.something}" }
            else
              DIV(id: :changed_component, on_click: :change_state) { "#{app_store.something}" }
            end
          end
        end
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('true')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('false')
    end

    it 'use a uninitialized store value and change it' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          def change_state(event)
            app_store.something = true
          end
          render do
            if app_store.something
              DIV(id: :changed_component, on_click: :change_state) { "#{app_store.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{app_store.something}here" }
            end
          end
        end
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('true')
    end
  end

  context 'it has styles and renders them' do
    before do
      @doc = visit('/')
    end

    it 'with the style prop' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          render do
            DIV(id: :test_component, style: { width: 100 }) { "nothinghere" }
          end
        end
        class OuterApp < LucidPaper::App::Base
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      # the following should be replaced by node.styles once its working correctly
      style = @doc.execute_script <<~JAVASCRIPT
        var styles = window.getComputedStyle(document.querySelector('#test_component'))
        return styles.width
      JAVASCRIPT
      expect(style).to eq('100px')
    end
  end

  context 'it has a theme and styles and renders them' do
    before do
      @doc = visit('/')
    end

    it 'with the style prop accessing theme' do
      @doc.evaluate_ruby do
        class TestComponent < LucidPaper::Func::Base
          render do
            DIV(id: :test_component, style: { width: theme.root.width }) { "nothinghere" }
          end
        end
        class OuterApp < LucidPaper::App::Base
          theme do
            { root: { width: 100 }}
          end
          render do
            TestComponent()
          end
        end
        Isomorfeus::TopLevel.mount_component(OuterApp, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      # the following should be replaced by node.styles once its working correctly
      style = @doc.execute_script <<~JAVASCRIPT
        var styles = window.getComputedStyle(document.querySelector('#test_component'))
        return styles.width
      JAVASCRIPT
      expect(style).to eq('100px')
    end
  end
end
