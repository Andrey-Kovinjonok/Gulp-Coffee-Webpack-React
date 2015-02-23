React = require 'react'

#ClickCounter = React.createClass
#  getInitialState: ->
#    numClicks: 0
#
#  click: ->
#    this.setState { numClicks: this.state.numClicks + 1 }
#
#  render: ->
#    (<div onClick={this.click}>
#        {this.state.numClicks} c li _ ck s
#      </div>
#    )

module.exports = React.createClass
  getInitialState: ->
    numClicks: 0
  click: ->
    this.setState { numClicks: this.state.numClicks + 1 }
  render: ->
    (<div className='main' onClick={this.click}>
        {this.state.numClicks} clicks
      </div>
    )