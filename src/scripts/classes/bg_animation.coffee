module.exports = class moveNarrows
  constructor: ->
    @el_back = document.getElementById 'narrows_back'
    @el_middle = document.getElementById 'narrows_middle'
    container = document.getElementById 'container'
    @container_height = container.scrollHeight
    @off = false
    @permament = false
    @checkMobileDevice()

  scrollController: (obj) ->
    page_offset = obj.pageYOffset or obj.scrollTop
    if page_offset >= @container_height
      if @off is false then @stop()
    else
      if @off is true then @start()

  stop: ->
    if @off is false
      console.log "Bg anmation disabled."
      @el_back.className = ''
      @el_middle.className = ''
      @off = true

  start: ->
    if @permament is false
      console.log "Bg animation enabled."
      @el_back.className = 'animated'
      @el_middle.className = 'animated'
      @off = false

  checkMobileDevice: ->
    if document.body.offsetWidth <= 600
      @permament = true
      @stop()