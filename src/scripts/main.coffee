'use strict'

PortfolioSlides = require 'classes/portfolio_slides'
PortfolioOverlay = require 'classes/portfolio_overlay'
SkillsBars = require 'classes/skills_bars'
Navigation = require 'classes/navigation'

portfolio_config = require 'config/portfolio_slides_config'
skills_config = require 'config/skills_bars_config'

initialization = (->
  skills = new SkillsBars skills_config
  portfolio = new PortfolioSlides portfolio_config
  overlay = new PortfolioOverlay portfolio_config
  navigation = new Navigation

  page = document.getElementById 'page_main'
  page.onscroll = (event) ->
    portfolio.scrollController(event.target)
    skills.scrollController(event.target)
)()