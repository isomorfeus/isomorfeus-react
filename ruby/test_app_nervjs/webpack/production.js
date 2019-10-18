const path = require('path');
const OwlResolver = require('opal-webpack-loader/resolver');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const common_config = {
    context: path.resolve(__dirname, '../isomorfeus'),
    mode: "production",
    optimization: {
        minimize: false
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
            "react": "nervjs",
            'react-dom/server': 'nerv-server/index',
            "react-dom": "nervjs"
        }
    },
    module: {
        rules: [
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
                            includePath: [path.resolve(__dirname, '../isomorfeus/styles')],
                            sourceMap: false // set to false to speed up hot reloads
                        }
                    }
                ]
            },
            {
                // loader for .css files
                test: /.css$/,
                use: [ "style-loader", "css-loader" ]
            },
            {
                test: /.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
                use: [ "file-loader" ]
            },
            {
                // opal-webpack-loader will compile and include ruby files in the pack
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
        application: [path.resolve(__dirname, '../isomorfeus/imports/application.js')]
    },
    plugins: [
        new WebpackAssetsManifest({ publicPath: true, merge: true }), // generate manifest
        new BundleAnalyzerPlugin({ analyzerMode: 'static', openAnalyzer: false, reportsFilename: 'report.html' })
    ],
};

const ssr_config = {
    target: 'node',
    entry: {
        application_ssr: [path.resolve(__dirname, '../isomorfeus/imports/application_ssr.js')]
    },
    plugins: [
        new WebpackAssetsManifest({ publicPath: true, merge: true }) // generate manifest
    ],
};

// const web_worker_config = {
//     target: 'webworker',
//     entry: {
//         web_worker: [path.resolve(__dirname, '../isomorfeus/imports/application_web_worker.js')]
//     },
//     plugins: [
//         new WebpackAssetsManifest({ publicPath: true, merge: true }) // generate manifest
//     ],
// };

const browser = Object.assign({}, common_config, browser_config);
const ssr = Object.assign({}, common_config, ssr_config);
// const web_worker = Object.assign({}, common_config, web_worker_config);

module.exports = [ browser ];
