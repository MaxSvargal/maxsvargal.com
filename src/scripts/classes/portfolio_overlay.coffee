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

	animate: (direction) ->
		setClasses = (fromobj, toobj) ->
			mainClass = 'pt-page'
			currentClass = 'pt-page-current'
			outClass = 'pt-page-rotateRoomLeftOut pt-page-ontop'
			inClass = 'pt-page-rotateRoomLeftIn'
			
			fromobj.className = "#{mainClass} #{outClass}"
			toobj.className = "#{mainClass} #{currentClass} #{inClass}"
			setTimeout(->
				toobj.className = "#{mainClass}"
				toobj.className = "#{mainClass} #{currentClass}"
			, 600)

		if direction is 'toportfolio'
			setClasses @main, @container
		else if direction is 'tomain'
			setClasses @container, @main


	popState: (event) =>
		console.log "Loaded history state ", event.state ? "index" : event.state
		s = event.state
		if s
			if s.onmain is true
				@animate 'tomain'
			else if s.name
				@createDom s
				@animate 'toportfolio'
		else
			history.pushState {onmain: true}, "Main", '/'

	initClickEvents: ->
		parent = document.getElementById 'portfolio'
		parent.addEventListener 'click', (event) =>
			event.preventDefault()
			t = event.target
			history.pushState {name: t.dataset.name}, t.dataset.title, t.dataset.href
	
			item_obj = document.getElementById "prtf_box_#{t.dataset.name}"
			if not item_obj
				@createDom t.dataset

			@animate 'toportfolio'

