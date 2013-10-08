'use strict'

moveNarrows = require 'classes/bg_animation'
portfolioSlides = require 'classes/portfolio_slides'
portfolioOverlay = require 'classes/portfolio_overlay'
skillsBars = require 'classes/skills_bars'

portfolio_config = require 'config/portfolio_slides_config'
skills_config = require 'config/skills_bars_config'

initialization = (->
  #bg_anim = new moveNarrows
  skills = new skillsBars skills_config
  portfolio = new portfolioSlides portfolio_config
  overlay = new portfolioOverlay portfolio_config
  window.onscroll = ->
    portfolio.scrollController()
    skills.scrollController()
  window.onresize = ->
    #portfolio.reDraw()
)()
