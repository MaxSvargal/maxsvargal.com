'use strict'

module.exports = class portfolioOverlay
  constructor: (@projects) ->
    @main = document.getElementById 'page_main'
    @container = document.getElementById "portfolio_overlay"
    @initClickEvents()
    window.addEventListener 'popstate', @popState

  createDom: (data) ->
    frag = document.createDocumentFragment()
    # Portfolio page
    el = document.createElement 'div'
    el.id = "prtf_box_#{data.name}"
    el.className = "prtf_box"
    el.style.backgroundColor = "rgba(#{data.bg_rgba})"
    # Images
    for img_name in data.images
      # Main image box
      box = document.createElement 'div'
      box.className = 'prtf-img-box'
      # Line with buttons
      header = document.createElement 'div'
      header.className = 'prtf-img-header'
      # Buttons in line
      for dotn in [0..2]
        dot = document.createElement 'span'
        header.appendChild dot
      # Portfolio image
      img = document.createElement 'img'
      img.className = 'prtf-img'
      img.src = "/images/portfolio/#{data.name}/#{img_name}"

      # Append to main box
      box.appendChild header
      box.appendChild img
      el.appendChild box

    # Navigation links
    btns_box = document.createElement 'div'
    btns_box.className = 'nav-btns-box'

    prew_btn = document.createElement 'a'
    prew_btn.href = '#'
    prew_btn.className = 'nav-btn prew-btn'
    prew_btn.innerHTML = 'Go back'

    next_btn = document.createElement 'a'
    next_btn.href = '#'
    next_btn.className = 'nav-btn next-btn'
    next_btn.innerHTML = 'Next project'

    btns_box.appendChild prew_btn
    btns_box.appendChild next_btn
    el.appendChild btns_box

    # Append to DOM
    frag.appendChild el
    @container.appendChild frag

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


  showProject: (name) ->
    # Clear container
    @container.innerHTML = ''
    #if @prew_btn
    #  @prew_btn.removeEventListener 'click'
    #Get info from config by name
    data = @projects[name]
    data.name = name
    @createDom data
    @registerBackEvent()
    @animate().toRight()

  registerBackEvent: ->
    listener = ->
      @animate().toLeft()

    @prew_btn = (document.getElementsByClassName 'prew-btn')[0]
    @prew_btn.addEventListener 'click', listener.bind(this), true
      
  popState: (event) =>
    console.log "Loaded history state ", event.state ? "index" : event.state
    s = event.state
    if s
      if s.name
        @showProject s.name
      else
        @animate().toLeft()
    else
      history.replaceState {onmain: true}, "Main", '/'

  initClickEvents: ->
    parent = document.getElementById 'portfolio'
    parent.addEventListener 'click', (event) =>
      event.preventDefault()
      d = event.target.dataset
      history.pushState {name: d.name}, d.name, "/project/#{d.name}"
      @showProject d.name




