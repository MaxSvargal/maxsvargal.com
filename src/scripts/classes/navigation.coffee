'use strict'

module.exports = class Navigation
  constructor: ->
    #@onHeaderClick()
    @onMenuClick()


  onHeaderClick: ->
    header = document.getElementById 'header'
    header.addEventListener 'click', =>
      el = document.getElementById 'page_main'
      @scrollTo el

  onMenuClick: ->
    el = document.getElementById 'page_main'
    menu = (document.getElementsByClassName 'main_manu')[0]
    menu.addEventListener 'click', (event) ->
      #
      # TODO: Remove hardcode
      #
      name = event.target.hash.slice 1
      o = 0
      switch name
        when 'design' then o = 700
        when 'frontend' then o = 1300
        when 'backend' then o = 2050
        when 'another' then o = 2750
        when 'portfolio' then o = 1000
        when 'contacts' then o = 10000
      el.scrollTop = o

  scrollTo: (el, offset = 0, duration = 1000) ->
    delta = offset / duration * 10
    setTimeout(=>
      el.scrollTop = el.scrollTop + delta
      if el.scrollTop <= offset
        @scrollTo el, duration - 10
    , 10)