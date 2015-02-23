#require("style-loader!./../stylus/main.styl")
#require("html-loader!./../views/index.jade")


require('../stylus/main.styl')

React = require 'react'

ClickCounter = require './clickCounter.cjsx'

React.render <ClickCounter />, document.body #getElementById('main')