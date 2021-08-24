const path = require('path');
// const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const TerserPlugin = require('terser-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (_env, options) => {
  const devMode = options.mode !== 'production';

  return {
    stats: "minimal",
    optimization: {
      minimizer: [
        new TerserPlugin({}),
        new CssMinimizerPlugin({})
      ]
    },
    entry: {
      // 'app': glob.sync('./vendor/**/*.js').concat(['./js/app.js']),
      'app': './js/app.js',
      'client': './js/client'
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/'
    },
    devtool: devMode ? 'eval-cheap-module-source-map' : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.[s]?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            'sass-loader',
          ],
        },
        // Load images with the asset module, WP5
        {
          //test: /\.(png|svg|jpe?g|gif)(\?.*$|$)/,
          test: /\.(ico|png|svg|jpg|jpeg|gif|svg|webp|tiff)$/i,
          type: "asset/resource",
          generator: {
            filename: "../images/[hash][ext][query]"
          }
        },
        // Load fonts with the asset module, WP5
        {
          test: /\.(woff|woff2|eot|ttf|otf)$/,
          type: "asset/resource",
          generator: {
            filename: "../fonts/[hash][ext][query]"
          }
        },
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin({
        patterns: [{ from: "static/", to: "./" }]
      }),
    ]
  }
};
