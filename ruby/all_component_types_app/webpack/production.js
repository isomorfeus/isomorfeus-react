const path = require('path');
const OwlResolver = require('opal-webpack-loader/resolver');
const CompressionPlugin = require("compression-webpack-plugin"); // for gzipping the packs
const TerserPlugin = require('terser-webpack-plugin'); // for minifying the packs
const WebpackAssetsManifest = require('webpack-assets-manifest');

const common_config = {
    context: path.resolve(__dirname, '../isomorfeus'),
    mode: "production",
    optimization: {
        minimize: true, // minimize
        minimizer: [new TerserPlugin({ parallel: true, cache: true })]
    },
    performance: {
        maxAssetSize: 20000000,
        maxEntrypointSize: 2000000
    },
    output: {
        filename: '[name]-[chunkhash].js', // include fingerprint in file name, so browsers get the latest
        path: path.resolve(__dirname, '../public/assets'),
        publicPath: '/assets/'
    },
    resolve: { plugins: [new OwlResolver('resolve', 'resolved')] }, // resolve ruby files
    module: {
        rules: [
            {
                test: /.scss$/,
                use: ["style-loader", "css-loader",
                    {
                        loader: "sass-loader",
                        options: {
                            includePath: [path.resolve(__dirname, '../isomorfeus/styles')],
                            sourceMap: false
                        }
                    }
                ]
            },
            {
                test: /.css$/,
                use: ["style-loader", "css-loader"]
            },
            {
                test: /.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
                use: ["file-loader"]
            },
            {
                test: /(\.js)?\.rb$/,
                use: [
                    {
                        loader: 'opal-webpack-loader', // opal-webpack-loader will compile and include ruby files in the pack
                        options: { sourceMap: false, hmr: false }
                    }
                ]
            }
        ]
    }
};

const browser_config = {
    target: 'web',
    entry: { application: [path.resolve(__dirname, '../isomorfeus/imports/application.js')] },
    plugins: [
        new CompressionPlugin({ test: /^((?!application_ssr).)*$/, cache: true }), // gzip compress, exclude application_ssr.js
        new WebpackAssetsManifest({ publicPath: true, merge: true }) // generate manifest
    ],
    externals: { crypto: 'Crypto' }
};

const ssr_config = {
    target: 'node',
    entry: { application_ssr: [path.resolve(__dirname, '../isomorfeus/imports/application_ssr.js')] },
    plugins: [
        new WebpackAssetsManifest({ publicPath: true, merge: true }) // generate manifest
    ]
};

const web_worker_config = {
    target: 'webworker',
    entry: { web_worker: [path.resolve(__dirname, '../isomorfeus/imports/application_web_worker.js')] },
    plugins: [
        new CompressionPlugin({ test: /^((?!application_ssr).)*$/, cache: true }), // gzip compress, exclude application_ssr.js
        new WebpackAssetsManifest({ publicPath: true, merge: true }) // generate manifest
    ],
    externals: { crypto: 'Crypto' }
};

const browser = Object.assign({}, common_config, browser_config);
const ssr = Object.assign({}, common_config, ssr_config);
const web_worker = Object.assign({}, common_config, web_worker_config);

module.exports = [ browser, ssr ];
