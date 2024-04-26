require 'opal'
require 'isomorfeus-react'
require_tree 'components'

# some native React code for comparing performance
# language=JS
%x{
  var ExampleJS = {};
  global.ExampleJS = ExampleJS;

  class ExampleJSFun extends global.React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      var rounds = parseInt(this.props.match.params.count);
      var result = []
      for (var i = 0; i < rounds; i ++) {
        result.push(global.React.createElement(global.ExampleJS.AnotherComponent, {key: i}));
      }
      return result;
    }
  }
  ExampleJS.Fun = ExampleJSFun;

  class ExampleJSAnotherComponent extends global.React.Component {
    constructor(props) {
      super(props);
      this.show_orange_alert = this.show_orange_alert.bind(this);
      this.show_red_alert = this.show_red_alert.bind(this);
    }
    show_orange_alert() {
      alert("ORANGE ALERT!");
    }
    show_red_alert() {
      alert("RED ALERT!");
    }
    render() {
      return global.React.createElement(global.ExampleJS.AComponent, { onClick: this.show_orange_alert, text: 'Yes' },
        global.React.createElement("span", { onClick: this.show_red_alert }, 'Click for red alert! (Child 1), '),
        global.React.createElement("span", null, 'Child 2, '),
        global.React.createElement("span", null, 'etc. '),
      );
    }
  }
  ExampleJS.AnotherComponent = ExampleJSAnotherComponent;

  class ExampleJSAComponent extends global.React.Component {
    constructor(props) {
      super(props);
      this.state = { some_bool: true };
      this.change_state = this.change_state.bind(this);
    }
    change_state() {
      this.setState({some_bool: !this.state.some_bool});
    }
    render() {
      return [
        global.React.createElement("span", { onClick: this.props.onClick }, 'Click for orange alert! Props: '),
        global.React.createElement("span", null, this.props.text),
        global.React.createElement("span", { onClick: this.change_state }, ', State is: ' + (this.state.some_bool ? 'true' : 'false') + ' (Click!)'),
        global.React.createElement("span", null, ', Children: '),
        global.React.createElement("span", null, this.props.children),
        global.React.createElement("span", null, ' '),
        global.React.createElement("span", null, '| ')
      ];
    }
  }
  ExampleJS.AComponent = ExampleJSAComponent;

  class ExampleJSRun extends global.React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      var rounds = parseInt(this.props.match.params.count)/10;
      var result = []
      for (var i = 0; i < rounds; i ++) {
        result.push(global.React.createElement(global.ExampleJS.AnotherComponent, {key: i}));
      }
      return result;
    }
  }
  ExampleJS.Run = ExampleJSRun;
}

React.start_app!
