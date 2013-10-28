'use strict'

module.exports = class Portfolio
	constructor: (@projects) ->
    #If no portfilio objects
    if typeof @projects isnt 'object'
      throw new Error 'You should pass input data of projects'
    # Cache height of main content before portfolio
    @from_above = document.getElementById "container"
    # DOM elements of generated slides 
    @objs = []
    # Create all DOM elements
    @createDom()

  createDom: ->
    container = document.getElementById "portfolio"
    frag = document.createDocumentFragment()
    for name, data of @projects
      # For native navigation link
      link = document.createElement 'a'
      link.className = "prtf_link"
      link.setAttribute "href", "/project/#{name}"

      # Create main image
      img = document.createElement 'div'
      img.id = "prtf_#{name}"
      img.className = "prtf-banner-img"
      img.style.backgroundImage = "url(/images/portfolio/#{name}/banner.jpg)"
      img.dataset.name = name
      img.dataset.href = "/project/#{name}"
      img.dataset.title = name

      link.appendChild img
      frag.appendChild link

      # Cache elements to array for faster animation
      @objs[name] = img
    container.appendChild frag

  # On scroll redraw all slides
  reDraw: (offset) ->
    i = 0
    for name, data of @objs
      k = (offset / 4) - 270 + (500 * i++)
      pos = k.toFixed 3
      @objs[name].style.backgroundPosition = "50% #{pos}px"

  # On every scroll page event this method started
  scrollController: ->
    page_offset = window.pageYOffset or document.body.scrollTop
    ptrf_offset = window.innerHeight + page_offset - @from_above.scrollHeight
    if ptrf_offset > 0
      @reDraw ptrf_offset

