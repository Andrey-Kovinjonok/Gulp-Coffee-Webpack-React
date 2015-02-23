#--------------------------------------------------------------
#

gulp = require 'gulp'


#jade = require 'gulp-jade'
#stylus = require 'gulp-stylus'

coffee = require 'gulp-coffee'

server = require 'gulp-express'

path = require 'path'

gwebpack = require 'gulp-webpack'

webpack = require 'webpack'
WebpackDevServer = require "webpack-dev-server"
ExtractTextPlugin = require "extract-text-webpack-plugin"

expressService = require('gulp-express-service');

devServer = {}
#--------------------------------------------------

output_path = 'build/'


#   ---EXPRESSS   ---
gulp.task 'express_coffee_to_js', ->
  gulp.src('./src/express_service.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('./' + output_path))
    #.pipe(expressService({file:'./build/express_service.js', NODE_ENV:'DEV'}))

gulp.task 'start_express', ->
    console.log('http://localhost:8080', 'http://localhost:8080/hello');
    server.run
      file: './' + output_path + 'express_service.js'
#-------------------------------------------------------------------------------------


#   --- ASSETS ---
gulp.task 'stylus', ->
#  gulp.src './src/stylus/*.styl'
#    .pipe stylus set:['compress']
#    .pipe gulp.dest './' + output_path + 'css'

gulp.task 'jade', ->
#  console.log('jade')
#  gulp.src './src/views/*.jade'
#    .pipe do jade
#    .pipe gulp.dest './' + output_path

gulp.task "prepare", ['stylus', 'jade'], ->
  #for example, you could to copy fonts in 'output_path' destination folder
  return
#-------------------------------------------------------------------------------------

#   --- WEBPACK   ---
gulp.task "invalidate webpack dev server", ->
  if devServer.invalidate?
    devServer.invalidate()
    console.log "devServer was invalidated"

gulp.task "webpack", (callback) ->
  # configure build
  process.env["NODE_ENV"] = JSON.stringify("production")
  webpackConfig = require "./webpack.config.coffee"
  webpackConfig.plugins = [
    #build
    new webpack.IgnorePlugin(/vertx/),
    new webpack.IgnorePlugin(/un~$/),
    new webpack.optimize.DedupePlugin(),
    #new webpack.optimize.UglifyJsPlugin(),
    #new webpack.DefinePlugin {
       # This has effect on the react lib size.
    #  "process.env": { NODE_ENV: JSON.stringify("production") }
    #}
    new ExtractTextPlugin('index.html', { disable: false, allChunks: true })
    new ExtractTextPlugin('main.css', { disable: false, allChunks: true})
    
  ]
  webpackConfig.resolve.modulesDirectories = ["..", "node_modules"]
  #webpackConfig.devtool = 'source-map'
  webpackConfig.devtool = 'source'
  #webpackConfig.quiet = true
  #webpackConfig.noInfo = true
  #webpackConfig.lazy = true
  webpackConfig.module.loaders.push({ test: /\.styl$/, loader: ExtractTextPlugin.extract("style", "css-loader!stylus-loader") })
  webpackConfig.module.loaders.push({ test: /\.jade$/, loader: ExtractTextPlugin.extract("jade", "html-loader!jade-html-loader") })
  #webpackConfig.module.loaders.push({ test: /\.html$/, loader: ExtractTextPlugin.extract("html", "html-loader") })
  #webpackConfig.module.loaders.push({ test: /\.css$/, loader: ExtractTextPlugin.extract("css", "css-loader") })


  # Run webpack.
  gulp.src('src/components/app.cjsx')
    .pipe(gwebpack(webpackConfig))
    .pipe(gulp.dest(output_path))

gulp.task "webpack-dev-server", (callback) ->
  # configure dev
  webpackConfig = require "./webpack.config.coffee"
  webpackConfig.plugins = [
    #dev
    new webpack.HotModuleReplacementPlugin()
    new webpack.NoErrorsPlugin()
    #new webpack.IgnorePlugin(/vertx/) # https://github.com/webpack/webpack/issues/353      
    #new webpack.NewWatchingPlugin()
    #new ExtractTextPlugin('main.css', { disable: false, allChunks: true})
    #new ExtractTextPlugin('index.html', { disable: false, allChunks: true })
    #new ExtractTextPlugin('[name].css')
    #new ExtractTextPlugin('[name].html')
  ]
  webpackConfig.module.loaders.push({ test: /\.jade$/, loader: "html!jade-html?outputStyle=expanded" })
  webpackConfig.module.loaders.push({ test: /\.styl$/, loader: "style!css!stylus?outputStyle=expanded" })
  #webpackConfig.resolve.modulesDirectories = ["node_modules"]
  #webpackConfig.devtool = 'eval'
  #webpackConfig.module.loaders.push({ test: /\.css$/, loader: "style-loader!css-loader" })
  #webpackConfig.module.loaders.push({ test: /\.styl$/, loader: "style-loader!css-loader!stylus-loader" })
  #webpackConfig.plugins.push(new ExtractTextPlugin("[name].css", {allChunks: true}))


  # Start a webpack-dev-server
  devServer = new WebpackDevServer(webpack(webpackConfig),
    
    #webpack-dev-server options
    contentBase: './' + output_path
    stats:
      colors: true
      timings: true
    hot: true
    #quiet: true
    noInfo: false
    debug: true
    #keepalive: true
    #lazy: true
    #filename: "app.js"
    #watchDelay: 300
    #publicPath: "/assets/"
    #headers: {"X-Custom-Header": "yes" }
  )

  devServer.listen 1337, 'localhost', (err, result) ->
    if err
      console.log err, " --- ", result
      throw new Error('webpack-dev-server', err)
    console.log '[webpack-dev-server]', 'http://localhost:1337/webpack-dev-server/index.html'
    callback()

  return
#-------------------------------------------------------------------------------------

gulp.task 'start', ['start_express'], ->

#   --- BUILD ---
gulp.task 'build', ['express_coffee_to_js', 'prepare', 'webpack'], ->
#-------------------------------------------------------------------------------------

#   ---WATCH   ---
gulp.task 'watch', ['webpack-dev-server'], ->
  #gulp.watch './src/views/*.jade', ['jade', 'invalidate webpack dev server']
  #gulp.watch './src/stylus/*.styl', ['stylus', 'invalidate webpack dev server']
  #gulp.watch './src/express_service.coffee', ['express_coffee_to_js']
#-------------------------------------------------------------------------------------

gulp.task 'default', ['watch']

