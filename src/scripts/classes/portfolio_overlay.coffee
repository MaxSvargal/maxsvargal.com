'use strict'

class portfolioOverlay
	constructor: (@projects) ->
		@container = document.getElementById "portfolio_overlay"
		@cube = document.getElementById 'cube'
		@initClickEvents()
		window.addEventListener 'popstate', @popState

	createDom: (data) ->
		@p_offset = window.pageYOffset or document.body.scrollTop
		el = document.createElement 'div'
		el.id = "prtf_box_#{data.name}"
		el.className = "prtf_box"
		el.innerHTML = "<a href='/next_project' class='next_project'>NEXT</a><h1>#{data.name}</h1><img src='/images/portfolio/4sound/banner.jpg'>"
		el.style.top = @p_offset + "px"
		@container.appendChild el
		@cube.className = 'cube rotated'

		setTimeout(=>
			#@container.style.height = 2000 + "px"
			el.style.top = 0
			window.scrollTo 0, 0
		, 1000)
		

	popState: (event) =>
		console.log "Loaded history state ", event.state ? "index" : event.state
		s = event.state
		if s
			if s.onmain is true
				setTimeout(=>
					window.scrollTo 0, @p_offset
					@container.innerHTML = ''
				, 1000)
				@cube.className = 'cube'
			else
				@createDom s
		else
			history.pushState {onmain: true}, "Main", '/'

	initClickEvents: ->
		parent = document.getElementById 'portfolio'
		parent.addEventListener 'click', (event) =>
			event.preventDefault()
			t = event.target
			@createDom t.dataset
			history.pushState {name: t.dataset.name}, t.dataset.title, t.dataset.href

module.exports = portfolioOverlay