require 'opal'
start = Time.now
require 'isomorfeus-redux'
ix_rt = Time.now
require 'isomorfeus-react'
ir_rt = Time.now
require 'isomorfeus-react-material-ui'
irmu_rt = Time.now
require 'isomorfeus-react-paper'
IR_PAPER_REQUIRE_TIME = (Time.now - irmu_rt) * 1000
IR_MATERIAL_REQUIRE_TIME = (irmu_rt - ir_rt) * 1000
IR_REACT_REQUIRE_TIME = (ir_rt - ix_rt) * 1000
IX_REQUIRE_TIME = (ix_rt - start) * 1000

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
start = Time.now
Isomorfeus.start_app!
IR_LOAD_TIME = (Time.now - start) * 1000
