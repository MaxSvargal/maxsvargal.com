'use strict'

moveNarrows = require 'classes/bg_animation'
portfolioCanvas = require 'classes/portfolio_canvas'
skillsBars = require 'classes/skills_bars'

portfolio_config = require 'config/portfolio_canvas_config'
skills_config = require 'config/skills_bars_config'

initialization = (->
	bg_anim = new moveNarrows
	skills = new skillsBars skills_config
	portfolio = new portfolioCanvas portfolio_config
	window.onscroll = ->
		portfolio.scrollController()
		skills.scrollController()
	window.onresize = ->
		portfolio.reDraw()
)()
