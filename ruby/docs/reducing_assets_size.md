### Reducing Asset Size
For convenience several `require` options are provided, to reduce assets size and provide only
what is really needed in many cases.

All sizes below are measured with isomorfeus-react 16.9.0.
For explanation of the sizes see the documentation of [Bundle Analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer)

require option | stat size | parsed size | gzip size
---------------|----------:|------------:|----------:|
`require 'isomorfeus-react'` | ~264kb | ~289kb | ~29kb
`require 'isomorfeus-react-material-ui'` | ~288kb | ~315kb | ~32kb

#### Available Components for each require option
Supported Components for `require 'isomorfeus-react'`
- FunctionComponent
- MemoComponent
- All from the 'Special React Features' section of the README.
- Most from the 'Other Features' section of the README.
- React::Component
- LucidApp
- LucidComponent

Supported Components for `require 'isomorfeus-react-material-ui'`
- all of isomorfeus-react
- LucidMaterial::App
- LucidMaterial::Component
