'use strict'

module.exports = class Navigation
  constructor: ->
    @onHeaderClick()
    window.addEventListener 'popstate', @popState

  onHeaderClick: ->
    header = document.getElementById 'header'
    header.addEventListener 'click', ->
      console.log 'clicked'
      document.body.scrollTop = "700px"

  popState: (event) ->
    s = event.state
    console.log s