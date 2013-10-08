'use strict'

class Portfolio
	constructor: (@projects) ->
    if typeof @projects isnt 'object'
      throw Error 'You should pass input data of projects'
    @item_height = 400
    @drawObj = {}
    @createDom()
    @initScrollController()

  createDom: ->
    container = document.getElementById "portfolio"
    frag = document.createDocumentFragment()
    doc_width = document.body.clientWidth
    for name, data of @projects 
      link = document.createElement 'a'
      link.className = "prtf_link"
      link.setAttribute "href", "/#!/project/#{name}"

      img = document.createElement 'div'
      img.id = "prtf_#{name}"
      img.className = "prtf-banner-img"
      #img.style.width = doc_width + 'px'
      #img.style.height = 300 + 'px'
      img.style.backgroundImage = "url(/images/portfolio/#{name}/banner.jpg)"
      
      link.appendChild img
      frag.appendChild link
    container.appendChild frag

  draw: (img, offset) ->
    #console.log(img, offset)

  initScrollController: ->
    from_above = document.getElementById "container"
    @start_point = from_above.scrollHeight - window.innerHeight 
    i = 0
    for name, data of @projects
      img = document.getElementById "prtf_#{name}"
      start = @start_point + @item_height * i++
      @drawObj[name] =
        img: img
        start: start
        end: start + @item_height
        draw: @draw.bind(this, img)

  scrollController: ->
    p_offset = window.pageYOffset or document.body.scrollTop
    if p_offset >= @start_point
      for name, data of @drawObj
        if p_offset >= data.start and p_offset <= data.end
          offset = (p_offset - data.start) / @item_height
          data.draw(offset.toFixed 3)
        if p_offset > data.end and p_offset < data.end + 50 #Add some margin because of fast scrolling
          data.draw 1 # Set to end state
        # Debug information
        #console.log "Offset: #{offset}; #{name}: Current offset is #{p_offset} from #{start} end on #{end}."


module.exports = Portfolio