'use strict'

module.exports = class Navigation
  constructor: ->
    window.addEventListener 'popstate', @popState
    @container = document.getElementById 'page_main'
    #@onHeaderClick()
    @onMenuClick()
    @loadFromUrl()

  popState: (event) =>
    if event.state
      if event.state.anchor
        stopY = @elmYPosition event.state.anchor
        scrollTo @container, stopY
      else if event.state.index is true
        scrollTo @container, 0

  onHeaderClick: ->
    header = document.getElementById 'logo_box'
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
    animate = ->
      parent.scrollTop = this.leap

    if stopY > startY
      i = startY
      while i < stopY
        setTimeout animate.bind({leap: leapY}), timer * speed
        leapY += step
        leapY = stopY  if leapY > stopY
        timer++
        i += step
    else
      i = startY
      while i > stopY
        setTimeout animate.bind({leap: leapY}), timer * speed 
        leapY -= step
        leapY = stopY if leapY < stopY
        timer++
        i -= step

  elmYPosition: (id) ->
    name = id.split('/')
    el = document.getElementById id
    if not el
      throw new Error "No element with id ##{id}"

    y = el.offsetTop
    node = el
    while node.offsetParent
      node = node.offsetParent
      y += node.offsetTop
    return y

  onMenuClick: ->
    menu = (document.getElementsByClassName 'main_manu')[0]
    links = menu.getElementsByTagName 'a'
    for link in links
      link.addEventListener 'click', (event) =>
        event.preventDefault()
        path = (event.target.getAttribute 'href').split('/')
        history.pushState {index: false, anchor: path[2]}, 'Section #{path[2]}', "/to/#{path[2]}"
        stopY = @elmYPosition path[2]
        scrollTo @container, stopY

  loadFromUrl: ->
    fullpath = window.location.pathname
    path = fullpath.split('/')
    if path[1] is 'to' and path[2]
      history.pushState {index: true}, 'Main', '/'
      history.pushState {anchor: path[2], index: false}, path[2], "/to/#{path[2]}"
      stopY = @elmYPosition path[2]
      scrollTo @container, stopY

