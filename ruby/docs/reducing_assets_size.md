### Reducing Asset Size
For convenience several `require` options are provided, to reduce assets size and provide only
what is really needed in many cases.

All sizes below are measured with isomorfeus-react 16.8.0.
For explanation of the sizes see the documentation of [Bundle Analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer)

require option | stat size | parsed size | gzip size
---------------|----------:|------------:|----------:|
`require 'isomorfeus-react-base'`| ~90kb | ~100kb | ~13kb
`require 'isomorfeus-react-component'` | ~161kb | ~177kb | ~19kb
`require 'isomorfeus-react-redux-component'` | ~180kb | ~197kb | ~22kb
`require 'isomorfeus-react-lucid'` | ~204kb | ~224kb | ~24kb
`require 'isomorfeus-react-material-ui'` | ~213kb | ~234kb | ~25kb
`require 'isomorfeus-react'` | ~259kb | ~289kb | ~30kb
everything (react + react-material-ui) | ~296kb | ~331kb | ~32kb

#### Available Components for each require option
Common Components, available with `require 'isomorfeus-react-base'`:
- FunctionComponent
- MemoComponent
- All from the 'Special React Features' section of the README.
- Most from the 'Other Features' section of the README.

Supported Components for `require 'isomorfeus-react-component'`:
- Common Components above
- React::Component
- React::PureComponent

Supported Components for `require 'isomorfeus-react-redux-component'`
- Common Components above
- React::ReduxComponent

Supported Components for `require 'isomorfeus-react-lucid'`
- Common Components above
- LucidApp
- LucidComponent

Supported Components for `require 'isomorfeus-react-material-ui'`
- Common Components above
- LucidMaterial::App
- LucidMaterial::Component

Supported Components for `require 'isomorfeus-react'`
- Common Components above
- React::Component
- React::PureComponent
- React::ReduxComponent
- LucidApp
- LucidComponent
