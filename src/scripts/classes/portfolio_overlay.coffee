'use strict'

module.exports = class portfolioOverlay
	constructor: (@projects) ->
		@main = document.getElementById 'page_main'
		@container = document.getElementById "portfolio_overlay"
		@initClickEvents()
		window.addEventListener 'popstate', @popState

	createDom: (data) ->
		@p_offset = window.pageYOffset or document.body.scrollTop
		el = document.createElement 'div'
		el.id = "prtf_box_#{data.name}"
		el.className = "prtf_box"
		el.innerHTML = "<a href='/next_project' class='next_project'>NEXT</a><h1>#{data.name}</h1><img src='/images/portfolio/4sound/banner.jpg'>"
		@container.appendChild el

	popState: (event) =>
		console.log "Loaded history state ", event.state ? "index" : event.state
		s = event.state
		if s
			if s.onmain is true
				@container.className = 'pt-page'
				@main.className = 'pt-page pt-page-current pt-page-moveFromRightFade'
				window.document.body.className = ''
			else
				@createDom s
		else
			history.pushState {onmain: true}, "Main", '/'

	initClickEvents: ->
		parent = document.getElementById 'portfolio'
		parent.addEventListener 'click', (event) =>
			event.preventDefault()
			t = event.target
			href = t.offsetParent.getAttribute 'href'
			history.pushState {name: t.dataset.name}, t.dataset.title, t.dataset.href
			
			@createDom t.dataset

			# Animation classes
			outClass = 'pt-page pt-page-current pt-page-moveToLeftFade'
			inClass = 'pt-page pt-page-current pt-page-moveFromRightFade pt-page-ontop'

			@main.className = outClass
			@container.className = inClass
			window.document.body.className = 'hidden-scroll'
