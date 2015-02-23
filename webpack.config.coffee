path = require "path"

ExtractTextPlugin = require "extract-text-webpack-plugin"

CommonsChunkPlugin = require("webpack").CommonsChunkPlugin
#options =
#  #prerender: false
#  #devServer: true
#  #hotComponents: true
#  #debug: true
#  devtool: 'eval' # "eval-source-map" # 'eval', 'source-map'
#
#  stats:
#    colors: true
#    timings: true
#  hot: true
#  quiet: true
#  noInfo: false
#  debug: true

#publicPath = "http://localhost:1337/build/" #if options.devServer then "http://localhost:1337/build/" else "/build/"
publicPath = 'build/'

isDev = process.env.NODE_ENV;

#style_loader = { test: /\.styl$/, loader: "stylus!css-loader!stylus-loader"}
#style_loader = { test: /\.styl$/, loader: ExtractTextPlugin.extract("stylus", "css-loader!stylus-loader")} if isDev


module.exports =
  entry:
    app: ['./src/components/app.cjsx', 'webpack/hot/dev-server', 'webpack-dev-server/client?http://localhost:1337']
    index:['./src/index.coffee', 'webpack/hot/dev-server', 'webpack-dev-server/client?http://localhost:1337']
    #styl:['./src/stylus/main', 'webpack/hot/dev-server', 'webpack-dev-server/client?http://localhost:1337']
    #['./src/scripts/router', 'webpack/hot/only-dev-server', 'webpack-dev-server/client?http://localhost:1337']

  output: 
    filename: "[name].js"
    path: path.join(__dirname, "build")  #+ if options.prerender then "/prerender" else "/public"
    #publicPath: publicPath
    #filename: "[name].js"
    #chunkFilename: if isDev then "[id].js" else "[id].js"
    #sourceMapFilename: "debugging/[file].map"
    #libraryTarget: if options.prerender then "commonjs2" else undefined
    #pathinfo: options.debug

  module:
    loaders: [
      # { test: /\.jsx?x/, loaders: ['react-hot', 'jsx?harmony'], exclude: /node_modules/ }
      # { test: /\.js$/, loaders: ['react-hot', 'jsx?harmony'] },
      # { test: /\.cjsx$/, loaders: ['react-hot', 'coffee', 'cjsx']},
      # { test: /\.css$/, loaders: ['style', 'css']},
      # { test: /\.jade/, loader: 'jade?outputStyle=expanded' },
      # { test: /\.html$/, loader: "html" },

      # { test: /\.jsx/, loader: 'jsx', query: { 'insertPragma=React.DOM' } },
      { test: /\.coffee$/, exclude: /\.express_service.coffee$/, loader: 'coffee-loader' }
      { test: /\.cjsx$/, loader: 'coffee-jsx-loader' }

      # { test: /\.jade$/, loader: ExtractTextPlugin.extract("jade-html", "html-loader!jade-html-loader") },
      # { test: /\.styl$/, loader: ExtractTextPlugin.extract("stylus", "css!stylus-loader") },

      # { test: /\.html$/, loader: "html!html?outputStyle=expanded" },
      # { test: /\.css$/, loader: "style!css?outputStyle=expanded" },

      # { test: /\.jade$/, loader: "html!jade-html?outputStyle=expanded" },
      # { test: /\.styl$/, loader: "style!css!stylus?outputStyle=expanded" },

    ]

  #resolveLoader:
  #  root: path.join(__dirname, "node_modules")
  #  alias: {} # {'react-proxy$': 'react-proxy/unavailable'}

  resolve: 
    #root: path.join(__dirname, "app")
    extensions: ['', '.jade', '.styl', '.cjsx', '.jsx', '.js']
    #alias: alias

  plugins: [
  ]
