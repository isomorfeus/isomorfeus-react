### Execution Environment
Code can run in 3 different environments:
- On the Browser, for normal execution
- On nodejs, for server side rendering
- On the server, for normal execution of server side code

The following helpers are available to determine the execution environment:
- `Isomorfeus.on_browser?` - true if running on the browser, otherwise false
- `Isomorfeus.on_ssr?` - true if running on node for server side rendering, otherwise false
- `Isomorfeus.on_server?` - true if running on the server, otherwise false
