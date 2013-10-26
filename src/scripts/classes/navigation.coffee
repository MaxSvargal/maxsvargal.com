'use strict'

module.exports = class Navigation
  constructor: ->
    @onHeaderClick()

  onHeaderClick: ->
    header = document.getElementById 'header'
    header.addEventListener 'click', ->
      console.log 'clicked'
      document.body.scrollTop = "700px"