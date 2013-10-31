'use strict'

module.exports = class Navigation
  constructor: ->
    @onHeaderClick()
    @onMenuClick()
    window.addEventListener 'popstate', @popState


  onHeaderClick: ->
    header = document.getElementById 'header'
    header.addEventListener 'click', =>
      el = document.getElementById 'page_main'
      @scrollTo el

  onMenuClick: ->
    menu = (document.getElementsByClassName 'main_manu')[0]
    menu.addEventListener 'click', (event) =>
      name = event.target.hash.slice 1
      switch name
        when 'design' then o = 100
        when 'frontend' then o = 200
        when 'backend' then o = 300
        when 'another' then o = 400
        when 'portfolio' then o = 1000
        when 'contacts' then o = 5000
      @scrollTo menu, o
        
      
      #el = document.getElementById name
      #console.log el.scrollTop

  popState: (event) ->
    s = event.state
    #console.log s

  scrollTo: (el, offset = 0, duration = 1000) ->
    delta = offset / duration * 10
    setTimeout(=>
      el.scrollTop = el.scrollTop + delta
      if el.scrollTop <= offset
        @scrollTo el, duration - 10
    , 10)