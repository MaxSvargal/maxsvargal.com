'use strict'

class portfolioOverlay
	constructor: (@projects) ->
		@container = document.getElementById "portfolio_overlay"
		@initUrlListener()

	createDom: (name) ->
		canvas = document.getElementById "prtf_#{name}"
		el = document.createElement 'div'
		el.id = "prtf_box_#{name}"
		el.className = "prtf_box"
		@container.appendChild el

	initUrlListener: ->
		if location.hash is "#!/project/vahtang"
			@createDom "vahtang"

	registerEventListener: (el) ->
		el.addEventListener 'click', -> #or data.src.onclick, but fuck ie.
			@initUrlListener

module.exports = portfolioOverlay