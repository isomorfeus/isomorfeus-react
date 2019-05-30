# language=JS
%x{
  class LucidRouter extends Opal.global.React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      if (Opal.Isomorfeus["$on_ssr?"]()) {
        var new_props = Object.assign({}, this.props, { location: Opal.Isomorfeus.TopLevel.$ssr_route_path() });
        return Opal.global.React.createElement(Opal.global.StaticRouter, new_props);
      } else {
        return Opal.global.React.createElement(Opal.global.BrowserRouter, this.props);
      }
    }
  }

  Opal.global.LucidRouter = LucidRouter;
}
