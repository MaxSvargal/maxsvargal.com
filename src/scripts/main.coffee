'use strict'

PortfolioSlides = require 'classes/portfolio_slides'
PortfolioOverlay = require 'classes/portfolio_overlay'
SkillsBars = require 'classes/skillbars'
Navigation = require 'classes/navigation'
Footer = require 'classes/footer'
BgAnimation = require 'classes/bg_animation'

portfolio_config = require 'config/portfolio_config'
skills_config = require 'config/skillbars_config'

initialization = (->
  skills = new SkillsBars skills_config
  portfolio = new PortfolioSlides portfolio_config
  bg_animation = new BgAnimation
  overlay = new PortfolioOverlay portfolio_config, bg_animation
  navigation = new Navigation
  footer = new Footer

  page = document.getElementById 'page_main'
  page.onscroll = (event) ->
    bg_animation.scrollController(event.target)
    portfolio.scrollController(event.target)
    skills.scrollController(event.target)
    footer.scrollController(event.target)
)()