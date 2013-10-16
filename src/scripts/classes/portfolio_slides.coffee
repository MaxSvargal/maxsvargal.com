'use strict'

module.exports = class Portfolio
	constructor: (@projects) ->
    if typeof @projects isnt 'object'
      throw Error 'You should pass input data of projects'
    @from_above = document.getElementById "container"
    @item_height = 400
    @objs = []
    @createDom()

  createDom: ->
    container = document.getElementById "portfolio"
    doc_width = document.body.clientWidth
    frag = document.createDocumentFragment()
    for name, data of @projects 
      link = document.createElement 'a'
      link.className = "prtf_link"
      link.setAttribute "href", "/project/#{name}"

      img = document.createElement 'div'
      img.id = "prtf_#{name}"
      img.className = "prtf-banner-img"
      img.style.width = doc_width + 'px'
      #img.style.height = 300 + 'px'
      img.style.backgroundImage = "url(/images/portfolio/#{name}/banner.jpg)"
      img.dataset.name = name
      img.dataset.href = "/project/#{name}"

      overlay = document.createElement 'div'
      overlay.className = "prtf_overlay"
      overlay.style.backgroundColor = "rgba(#{data.bg_rgba})"

      link.appendChild img
      link.appendChild overlay
      frag.appendChild link
      # Add to objects array for animations
      @objs[name] = img
    container.appendChild frag

  reDraw: (offset) ->
    i = 0
    for name, data of @objs
      k = (offset / 4) - 270 + (400 * i++)
      pos = k.toFixed 3
      @objs[name].style.backgroundPosition = "50% #{pos}px"

  scrollController: ->
    page_offset = window.pageYOffset or document.body.scrollTop
    ptrf_offset = window.innerHeight + page_offset - @from_above.scrollHeight
    if ptrf_offset > 0
      @reDraw ptrf_offset

