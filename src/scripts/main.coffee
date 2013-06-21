moveNarrows = ->
	el_back = document.getElementById 'narrows_back'
	el_middle = document.getElementById 'narrows_middle'
	pos = 0

	move = ->
		pos++
		el_back.style.backgroundPositionY = "-#{pos}px"
		el_middle.style.backgroundPositionY = "-#{pos*2}px"
	window.setInterval move, 70

moveNarrows()