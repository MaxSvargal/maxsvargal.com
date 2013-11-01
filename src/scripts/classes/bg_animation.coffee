module.exports = class moveNarrows
  constructor: ->
    @el_back = document.getElementById 'narrows_back'
    @el_middle = document.getElementById 'narrows_middle'
    @start()

  start: ->
    pos = 0
    move = =>
      @el_back.style.backgroundPositionY = "-#{pos}px"
      @el_middle.style.backgroundPositionY = "-#{pos*2}px"
      pos++
    window.setInterval move, 70