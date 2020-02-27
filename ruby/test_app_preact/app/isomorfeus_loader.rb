require 'opal'
start = Time.now
require 'isomorfeus-redux'
IX_REQUIRE_TIME = (Time.now - start) * 1000
start = Time.now
require 'isomorfeus-react'
require 'isomorfeus-react-material-ui'
IR_REQUIRE_TIME = (Time.now - start) * 1000
%x{
  class NativeComponent extends Opal.global.React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      return Opal.global.React.createElement('div', null, 'A');
    }
  }
  Opal.global.NativeComponent = NativeComponent;

  class TopNativeComponent extends Opal.global.React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      return Opal.global.React.createElement('div', null, 'TopNativeComponent');
    }
  }
  Opal.global.TopNativeComponent = TopNativeComponent;

  Opal.global.NestedNative = {};
  class AnotherComponent extends Opal.global.React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      return Opal.global.React.createElement('div', null, 'NestedNative.AnotherComponent');
    }
  }
  Opal.global.NestedNative.AnotherComponent = AnotherComponent;
}

require_tree 'components', :autoload

Isomorfeus.start_app!
IR_LOAD_TIME = (Time.now - start) * 1000
