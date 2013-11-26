'use strict'

module.exports = class portfolioOverlay
  constructor: (@projects, @bg_animation) ->
    @main = document.getElementById 'page_main'
    @container = document.getElementById "portfolio_overlay"
    @loadFromUrl()
    @initClickEvents()
    window.addEventListener 'popstate', @popState
    @preloadFirstImages()

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
      if data.link
        box = document.createElement 'a'
        box.href = data.link
        box.target = "_blank"
      else # If no link in congig
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
    prew_btn.href = '/'
    prew_btn.className = 'nav-btn prew-btn'
    prew_btn.innerHTML = 'To main'

    next_btn = document.createElement 'a'
    next_btn.href = "/project/#{@getNextProjectName()}"
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

    toNext: =>
      leftObj = document.getElementById "prtf_box_#{@getPrewProjectName()}"
      rightObj = document.getElementById "prtf_box_#{@curr_project}"

      leftObj.className = "#{mainClass} #{currentClass} pt-page-rotateRoomTopOut"
      rightObj.className = "#{mainClass} #{currentClass} pt-page-rotateRoomTopIn"
      setTimeout(->
        leftObj.remove()
        rightObj.className = "prtf_box #{currentClass}"
      , 1000)


  showProject: (name) ->
    @bg_animation.stop()
    @curr_project = name
    @preloadImages @getNextProjectName()
    #Get info from config by name
    data = @projects[name]
    data.name = name
    @createDom data
    @registerBackEvent()
    @registerNextEvent()

    fromMain: =>
      @animate().toRight()
    fromProject: =>
      @animate().toNext()

  clearContainer: (delay = 1000) ->
    if delay is 0
      @container.innerHTML = ''
    else
      setTimeout(=>
        @container.innerHTML = ''
      , delay)

  registerBackEvent: ->
    listener = (event) ->
      event.preventDefault()
      @animate().toLeft()
      @clearContainer()

    prew_btns = document.getElementsByClassName 'prew-btn'
    for btn in prew_btns
      btn.addEventListener 'click', listener.bind(this)

  registerNextEvent: ->
    listener = (event) ->
      event.preventDefault()
      name = @getNextProjectName()
      if not name
        @animate().toLeft()
        @clearContainer()
      else
        @showProject(name).fromProject()
        #history.pushState {name: name, from_main: false}, name, "/project/#{name}"

    next_btns = document.getElementsByClassName 'next-btn'
    for btn in next_btns
      btn.addEventListener 'click', listener.bind(this)


  getNextProjectName: ->
    keys = Object.keys(@projects)
    index = keys.indexOf @curr_project
    keys[index + 1]

  getPrewProjectName: ->
    keys = Object.keys(@projects)
    index = keys.indexOf @curr_project
    keys[index - 1]

  loadFromUrl: ->
    fullpath = window.location.pathname
    path = fullpath.split('/')
    if path[1] is 'project' and path[2]
      history.pushState {index: false}, 'Main', '/'
      history.pushState {name: path[2], from_main: true}, path[2], "/project/#{path[2]}"
      @showProject(path[2]).fromMain()
      
  popState: (event) =>
    console.log "Loaded history state ", event.state ? "index" : event.state
    s = event.state
    if s
      if s.name
        if s.from_main is true
          @clearContainer 0
          @showProject(s.name).fromMain()
        else
          console.log "TODO: Draw prew animation"

      if s.index is false
        @animate().toLeft()

  initClickEvents: ->
    parent = document.getElementById 'portfolio'
    parent.addEventListener 'click', (event) =>
      event.preventDefault()
      d = event.target.dataset
      history.pushState {name: d.name, from_main: true}, d.name, "/project/#{d.name}"
      @clearContainer 0
      @showProject(d.name).fromMain()

  preloadImages: (project) ->
    obj = @projects[project]
    if obj then for img_name in obj.images
      img = new Image()
      img.src = "/images/portfolio/#{project}/#{img_name}"

  preloadFirstImages: ->
    keys = Object.keys(@projects)
    name = keys[0]
    @preloadImages name

