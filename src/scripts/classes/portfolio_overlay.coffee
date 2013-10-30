'use strict'

module.exports = class portfolioOverlay
  constructor: (@projects) ->
    @main = document.getElementById 'page_main'
    @container = document.getElementById "portfolio_overlay"
    @initClickEvents()
    window.addEventListener 'popstate', @popState

  createDom: (data) ->
    @p_offset = window.pageYOffset or document.body.scrollTop
    el = document.createElement 'div'
    el.id = "prtf_box_#{data.name}"
    el.className = "prtf_box"
    el.innerHTML = "<a href='/next_project' class='next_project'>NEXT</a><h1>#{data.name}</h1><img src='/images/portfolio/4sound/banner.jpg'>"
    @container.appendChild el

  animate: ->
    leftObj = @main
    rightObj = @container

    mainClass = 'pt-page'
    currentClass = 'pt-page-current'
    onTopClass = 'pt-page-ontop'
    outClassLeft = 'pt-page-rotateRoomLeftOut'
    inClassLeft = 'pt-page-rotateRoomLeftIn'
    outClassRight = 'pt-page-rotateRoomRightOut'
    inClassRight = 'pt-page-rotateRoomRightIn'

    toLeft: ->
      rightObj.className = "#{mainClass} #{currentClass} #{outClassRight}"
      leftObj.className = "#{mainClass} #{currentClass} #{inClassRight}"
      setTimeout(->
        rightObj.className = "#{mainClass}"
        leftObj.className = "#{mainClass} #{currentClass}"
      , 1000)

    toRight: ->
      leftObj.className = "#{mainClass} #{currentClass} #{outClassLeft}"
      rightObj.className = "#{mainClass} #{currentClass} #{inClassLeft}"
      setTimeout(->
        leftObj.className = "#{mainClass}"
        rightObj.className = "#{mainClass} #{currentClass}"
      , 1000)


  popState: (event) =>
    console.log "Loaded history state ", event.state ? "index" : event.state
    s = event.state
    if s
      if s.onmain is true
        @animate().toLeft()
      else if s.name
        @createDom s
        @animate().toRight()
    else
      history.pushState {onmain: true}, "Main", '/'

  initClickEvents: ->
    parent = document.getElementById 'portfolio'
    parent.addEventListener 'click', (event) =>
      event.preventDefault()
      t = event.target
      history.pushState {name: t.dataset.name}, t.dataset.title, t.dataset.href
  
      item_obj = document.getElementById "prtf_box_#{t.dataset.name}"
      if not item_obj
        @createDom t.dataset

      @animate().toRight()
