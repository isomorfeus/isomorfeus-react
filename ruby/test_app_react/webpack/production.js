const path = require('path');
const OwlResolver = require('opal-webpack-loader/resolver');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const common_config = {
    context: path.resolve(__dirname, '../app'),
    mode: "production",
    optimization: {
        minimize: true
    },
    performance: {
        maxAssetSize: 20000000,
        maxEntrypointSize: 20000000
    },
    output: {
        filename: '[name]-[chunkhash].js', // include fingerprint in file name, so browsers get the latest
        path: path.resolve(__dirname, '../public/assets'),
        publicPath: '/assets/'
    },
    resolve: {
        plugins: [
            new OwlResolver('resolve', 'resolved') // resolve ruby files
        ],
        alias: {
            'react-native$': require.resolve('react-native-web')
        }
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: [/node_modules[/\\](?!react-native-vector-icons|react-native-safe-area-view)/, /.*\/opal\/corelib\/runtime.js$/],
                use: {
                    loader: 'babel-loader',
                    options: {
                        // Disable reading babel configuration
                        babelrc: false,
                        configFile: false,
                        // The configuration for compilation
                        presets: [
                            ['@babel/preset-env', { corejs: 3, useBuiltIns: 'usage' }],
                            '@babel/preset-react',
                            '@babel/preset-flow',
                            '@babel/preset-typescript'
                            ],
                        plugins: [
                            '@babel/plugin-proposal-class-properties',
                            '@babel/plugin-proposal-object-rest-spread'
                        ],
                    },
                },
            },
            {
                test: /.scss$/,
                use: [
                    { loader: "style-loader" },
                    {
                        loader: "css-loader",
                        options: {
                            sourceMap: false, // set to false to speed up hot reloads
                            minimize: true // set to false to speed up hot reloads
                        }
                    },
                    {
                        loader: "sass-loader",
                        options: {
                            includePath: [path.resolve(__dirname, '../app/styles')],
                            sourceMap: false // set to false to speed up hot reloads
                        }
                    }
                ]
            },
            {
                test: /.css$/,
                use: [ "style-loader", "css-loader" ]
            },
            {
                test: /.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
                use: [ "file-loader" ]
            },
            {
                test: /.(rb|js.rb)$/,
                use: [
                    {
                        loader: 'opal-webpack-loader',
                        options: {
                            sourceMap: false,
                            hmr: false
                        }
                    }
                ]
            }
        ]
    }
};

const browser_config = {
    target: 'web',
    entry: {
        application: [path.resolve(__dirname, '../app/imports/application.js')]
    },
    plugins: [
        new WebpackAssetsManifest({ publicPath: true, merge: true }), // generate manifest
        new BundleAnalyzerPlugin({ analyzerMode: 'static', openAnalyzer: false, reportsFilename: 'report.html' })
    ],
};

const ssr_config = {
    target: 'node',
    entry: {
        application_ssr: [path.resolve(__dirname, '../app/imports/application_ssr.js')]
    },
    plugins: [
        new WebpackAssetsManifest({ publicPath: true, merge: true }) // generate manifest
    ],
};

const browser = Object.assign({}, common_config, browser_config);
const ssr = Object.assign({}, common_config, ssr_config);

module.exports = [ browser, ssr ];
