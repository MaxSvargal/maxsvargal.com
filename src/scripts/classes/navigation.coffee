'use strict'

module.exports = class Navigation
  constructor: ->
    @container = document.getElementById 'page_main'
    @onHeaderClick()
    @onMenuClick()

  onHeaderClick: ->
    header = document.getElementById 'header'
    header.addEventListener 'click', =>
      scrollTo @container, 750


  scrollTo = (parent, stopY) ->
    startY = parent.scrollTop
    distance = if stopY > startY then stopY - startY else startY - stopY
    speed = Math.round distance / 100
    if speed < 50 then speed = 20
    step = Math.round distance / 25
    leapY =  if stopY > startY then startY + step else startY - step
    timer = 0
    if stopY > startY
      animate = ->
        parent.scrollTop = this.leap
      i = startY
      while i < stopY
        setTimeout animate.bind({leap: leapY}), timer * speed
        leapY += step
        leapY = stopY  if leapY > stopY
        timer++
        i += step

  onMenuClick: ->
    menu = (document.getElementsByClassName 'main_manu')[0]
    links = menu.getElementsByTagName 'a'
    for link in links
      link.addEventListener 'click', (event) =>
        event.preventDefault()
        name = event.target.hash.slice 1
        el = document.getElementById name
        if not el
          throw new Error "No element with id ##{name}"
        rect = el.getBoundingClientRect()
        scrollTo @container, rect.top