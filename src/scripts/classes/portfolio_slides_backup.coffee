  constructor: (@projects) ->
    if typeof @projects isnt 'object'
      throw Error 'You should pass input data of projects'
    @drawObj = {}
    @item_height = 400
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

      canvas = document.createElement 'canvas'
      canvas.id = "prtf_#{name}"
      canvas.width = doc_width
      canvas.height = @item_height

      link.appendChild canvas
      frag.appendChild link
    container.appendChild frag

  makeImage: (name) ->
    img = new Image
    # After looping on all images event is set to last - classic closure problem.
    img.onload = ((nr) =>
      =>
        @drawObj[name].draw(1)
    )(name)
    img.src = "/images/portfolio/#{name}/banner.jpg"
    img

  drawCanvas: (src, img, offset) ->
    src.height = @item_height
    context = src.getContext '2d'

    # Fill canvas for visual fix low rendering speed
    context.fillStyle = 'black'
    context.fillRect(0, 0, src.width, @item_height)

    #Calculate coordinate for centered image
    if window.outerWidth <= img.width
      width_offset = -((img.width / 2) - (window.outerWidth / 2))
    else
      width_offset = (window.outerWidth / 2) - (img.width / 2)

    context.scale(1, offset)
    context.drawImage(img, width_offset, 0)

    grd = context.createLinearGradient 0, 0, 0, @item_height
    grd.addColorStop 0, "rgba(255, 253, 241, #{0.5-offset})"
    grd.addColorStop 0.5, "rgba(255, 253, 241, #{1-offset})"
    grd.addColorStop 0.5, "rgba(0, 0, 0, #{1-offset})"
    grd.addColorStop 1, "rgba(0, 0, 0, #{0.7-offset})"

    context.fillStyle = grd
    context.fillRect(0, 0, src.width, @item_height)

  reDraw: ->
    @scrollController()
    for name, data of @drawObj
      data.src.width = window.outerWidth
      data.src.height = @item_height
      data.draw 1

  initScrollController: ->
    from_above = document.getElementById "container"
    @start_point = from_above.scrollHeight - window.innerHeight 
    i = 0
    for name, data of @projects
      canvas = document.getElementById "prtf_#{name}"
      img = @makeImage name
      start = @start_point + @item_height * i++
      @drawObj[name] =
        src: canvas
        img: img
        start: start
        end: start + @item_height
        draw: @drawCanvas.bind(this, canvas, img)

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
