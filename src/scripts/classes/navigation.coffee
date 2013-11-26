'use strict'

module.exports = class Navigation
  constructor: ->
    #@onHeaderClick()
    @onMenuClick()
    container = document.getElementById 'page_main'
    @container = container.parentNode

  onHeaderClick: ->
    header = document.getElementById 'header'
    header.addEventListener 'click', =>
      el = document.getElementById 'page_main'
      @scrollTo el


  scrollTo = (stopY) ->
    startY = @container.scrollTop
    distance = if stopY > startY then stopY - startY else startY - stopY
    speed = Math.round distance / 100
    if speed < 50 then speed = 20
    step = Math.round distance / 25
    leapY =  if stopY > startY then startY + step else startY - step
    timer = 0
    if stopY > startY
      i = startY
      while i < stopY
        setTimeout(=>
          console.log @container
          @container.scrollTop = leapY
        , timer * speed)
        leapY += step
        leapY = stopY  if leapY > stopY
        timer++
        i += step
      ###
      while startY < stopY
        setTimeout(->
          console.log timer, speed
          @container.scrollTo = leapY
          leapY += step
          if leapY > stopY then leapY - stopY
          timer++
        , timer * speed)
      ###

  onMenuClick: ->
    menu = (document.getElementsByClassName 'main_manu')[0]
    links = menu.getElementsByTagName 'a'
    for link in links
      link.addEventListener 'click', (event) ->
        #event.preventDefault()
        name = event.target.hash.slice 1
        el = document.getElementById name
        if not el
          throw new Error "No element with id ##{name}"
        rect = el.getBoundingClientRect()
        scrollTo rect.top

###
  scrollTo: (el, offset = 0, duration = 1000) ->
    delta = offset / duration * 10
    setTimeout(=>
      el.scrollTop = el.scrollTop + delta
      if el.scrollTop <= offset
        @scrollTo el, duration - 10
    , 10)
###