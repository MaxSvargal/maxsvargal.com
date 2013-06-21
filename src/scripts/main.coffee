'use strict'

moveNarrows = ->
	el_back = document.getElementById 'narrows_back'
	el_middle = document.getElementById 'narrows_middle'
	pos = 0

	move = ->
		pos++
		el_back.style.backgroundPositionY = "-#{pos}px"
		el_middle.style.backgroundPositionY = "-#{pos*2}px"
	window.setInterval move, 70

class portfolioCanvas
		constructor: (@projects) ->
			console.log @projects
			@makeImg for img in @projects

		draw: (img, offset) ->
			src = document.getElementById 'prtf_src'
			src.width = document.body.clientWidth
			src.height = 300
			context = src.getContext '2d'

			context.scale(1, offset)
			context.drawImage(img, 0, 0)

			grd = context.createLinearGradient 0, 0, 0, src.height
			grd.addColorStop 0, 'transparent'
			grd.addColorStop 0.5, "rgba(255, 255, 255, #{1-offset})"
			grd.addColorStop 0.5, 'transparent'
			grd.addColorStop 1, "rgba(0, 0, 0, #{1-offset})"

			context.fillStyle = grd
			context.fillRect(0, 0, src.width, src.height)

		makeImg: (img) ->
			console.log img
			img = new Image
			img.onload = => 
				@draw img, 1
			window.onscroll = =>
				p_offset = window.pageYOffset
				if p_offset >= 226 and p_offset <= 226+300
					current = p_offset - 226
					start = 226
					end = start + 300
					offset = (current / end)
					console.log offset
					@draw img, offset*2
			img.src = 'images/vahtang.jpg'

		load: ->
			@makeImg()

port = new portfolioCanvas
	vahtang:
		img: 'images/vahtang.jpg'
	test:
		img: 'images/vahtang.jpg'
	demo:
		img: 'images/vahtang.jpg'

port.load()


moveNarrows()