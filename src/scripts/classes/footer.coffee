'use strict'

module.exports = class Footer
  constructor: ->
    @btns = document.getElementsByClassName 'footer-buttons'
    @footer = (document.getElementsByClassName 'footer')[0]
    @container = document.getElementById 'container'
    @portfolio = document.getElementById 'portfolio'
    @checked = false

  scrollController: (obj) ->
    if @checked is false
      page_height = @container.clientHeight + @portfolio.clientHeight
      page_offset = obj.pageYOffset or obj.scrollTop
      console.log page_height
      if page_offset >= page_height
        @checked = true
        setClassName = ->
          @className = (@className.split ' ')[1]

        for btn in @btns[0].children
          delay = Math.floor Math.random()*2000+1
          setTimeout(setClassName.bind(btn), delay)