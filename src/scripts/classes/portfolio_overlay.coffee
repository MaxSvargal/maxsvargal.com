'use strict'

class portfolioOverlay
	constructor: (@projects) ->
		@container = document.getElementById "portfolio_overlay"
		window.onload = @route
		window.onpopstate = @popState

	createDom: (name) ->
		canvas = document.getElementById "prtf_#{name}"
		el = document.createElement 'div'
		el.id = "prtf_box_#{name}"
		el.className = "prtf_box"
		el.innerHTML = "<h1>#{name}</h1>"
		@container.appendChild el

	route: (evet) =>
		exp = location.hash.match /^#\!\/project\/(\w{1,})$/i 
		if exp and url_name = exp[1]
			#ext_name = for name is url_name in @projects
			#console.log ext_name
			@createDom name
			#if not history.pushState return
			history.pushState({project: name}, "", location.hash)

	popState: (event) =>
		@route()
		if event.state
			console.log event.state
		else
			console.log location.hash
			history.replaceState(@state, "", location.hash)

module.exports = portfolioOverlay