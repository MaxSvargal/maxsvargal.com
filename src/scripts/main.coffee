'use strict'

moveNarrows = ->
	el_back = document.getElementById 'narrows_back'
	el_middle = document.getElementById 'narrows_middle'
	pos = 0

	move = ->
		el_back.style.backgroundPositionY = "-#{pos}px"
		el_middle.style.backgroundPositionY = "-#{pos*2}px"
		pos++
	window.setInterval move, 70


#Canvas render for portfolio items 
class portfolioCanvas
	constructor: (@projects) ->
		if typeof @projects is 'undefined' or @projects isnt 'array'
			'You should pass input data of projects'
		@item_height = 300
		@createDom()
		@makeImages()
		@scrollController()

	createDom: ->
		container = document.getElementById 'portfolio'
		frag = document.createDocumentFragment()
		doc_width = document.body.clientWidth
		for name, data of @projects	
			canvas = document.createElement 'canvas'
			canvas.id = "prtf_#{name}"
			canvas.width = doc_width
			canvas.height = @item_height
			frag.appendChild canvas
		container.appendChild frag

	makeImages: ->
		for name, data of @projects	
			img = new Image
			#
			# After looping on all images event is set to last - classic closure problem.
			#
			img.onload = ((nr) =>
				=>
					@drawCanvas nr, img, 1
			)(name)
			img.src = data.src
			@projects[name].img = img

	drawCanvas: (name, img, offset) ->
		src = document.getElementById "prtf_#{name}"
		src.height = @item_height
		context = src.getContext '2d'

		# Fill canvas element for visual fix low rendering speed
		context.fillStyle = 'black'
		context.fillRect(0, 0, src.width, @item_height)
		context.scale(1, offset)
		context.drawImage(img, 0, 0)

		grd = context.createLinearGradient 0, 0, 0, @item_height
		grd.addColorStop 0, "rgba(255, 253, 241, #{0.5-offset})"
		grd.addColorStop 0.5, "rgba(255, 253, 241, #{1-offset})"
		grd.addColorStop 0.5, "rgba(0, 0, 0, #{1-offset})"
		grd.addColorStop 1, "rgba(0, 0, 0, #{1-offset})"

		context.fillStyle = grd
		context.fillRect(0, 0, src.width, @item_height)

	scrollController: ->
		header = document.getElementById "container"
		@start_point = header.scrollHeight - window.innerHeight + 140

		# Bind items render to global scroll
		p_offset = window.pageYOffset or document.body.scrollTop
		if p_offset >= @start_point
			i = 0
			for name, data of @projects
				start = @start_point + @item_height * i 
				end = start + @item_height
				if p_offset >= start and p_offset <= end
					offset = (p_offset - start) / @item_height
					@drawCanvas name, @projects[name].img, offset.toFixed 2
				if p_offset > end and p_offset < end + 50
					@drawCanvas name, @projects[name].img, 1
				i++
				# Debug information
				#console.log "Offset: #{offset}"; #{name}: Current offset is #{p_offset} from #{start} end on #{end}.

class skillsBars
	constructor: (@config) ->
		@bar_width = 300
		for name, group of @config
			@createDom name, group
		@scrollController()

	getAbilityLevel: (progress) ->
		switch
			when progress <= 0.3 then "basic"
			when progress <= 0.6 then "intermediate"
			when progress <= 0.8 then "advanced"
			when progress <= 1 then "expert"
			else "excellent"

	createDom: (name, group) ->
		container = document.getElementById 'skills'
		frag = document.createDocumentFragment()
		cgroup = document.createElement 'div'
		cgroup.className = "group #{name}"
		cgroup.id = "sk_bar_#{name}"
		for bname, data of group
			for item in data
				box = document.createElement 'div'
				box.className = "box"

				label = document.createElement 'label'
				label.className = "label"
				label.innerHTML = item.name

				bar = document.createElement 'div'
				#bar.id = "sk_bar_#{item.name}"
				bar.className = "bar #{name}"
				bar.dataset.width = @bar_width * item.progress

				bar_label = document.createElement 'span'
				bar_label.innerHTML = @getAbilityLevel item.progress
				
				bar.appendChild bar_label
				box.appendChild label
				box.appendChild bar
				cgroup.appendChild box
		frag.appendChild cgroup
		container.appendChild frag

	animateBars: (name) ->
		group = document.getElementById "sk_bar_#{name}"
		return if group.style.disabled is true
		group.style.disabled = true

		elems = group.getElementsByClassName 'box'

		animate = (opts) ->
			start = new Date
			delta = opts.delta
			timer = setInterval( ->
				progress = (new Date - start) / opts.duration
				if progress > 1 then progress = 1
				opts.step opts.delta(progress)
				if progress is 1
					clearInterval timer
					opts.complete and opts.complete()
			, opts.delay or 13)

		delta = (progress) ->
			Math.pow progress, 4

		animate
			delay: 10
			duration: 1600
			delta: delta
			step: (delta) ->
				for el in elems
					do (el) ->
						bar = el.getElementsByClassName 'bar'
						label = el.getElementsByTagName 'span'
						bar[0].style.width = bar[0].dataset.width * delta + 'px'
						label[0].style.opacity = delta

	scrollController: ->
		header = document.getElementById "header"
		start = header.scrollHeight - window.innerHeight + 220
		p_offset = window.pageYOffset or document.body.scrollTop
		#console.log start, p_offset
		i = 0
		if p_offset >= start
			for name, obj of @config
				if p_offset >= start+350*i then @animateBars name
				i++


initialization = (->
	moveNarrows()
	portfolio = new portfolioCanvas
		vahtang:
			src: 'images/vahtang.jpg'
		test:
			src: 'images/vahtang.jpg'
		demo:
			src: 'images/vahtang.jpg'

	skills = new skillsBars 
			"design":
				settings:
					text: "Hello, design!"
				data: [
					name: "web-design"
					progress: 0.9
				,
					name: "typography"
					progress: 0.6
				,
					name: "illustrations"
					progress: 0.3
				,
					name: "usability"
					progress: 1
				]

			"coding":
				settings:
					text: "Hello, coding!"
				data: [
					name: "html (jade, haml)"
					progress: 1
				,
					name: "css (sass)"
					progress: 0.9
				,
					name: "javascript"
					progress: 0.75
				,
					name: "coffeescript"
					progress: 0.61
				]

			"programming":
				data: [
					name: "node.js"
					progress: 0.61
				,
					name: "ruby on rails"
					progress: 0.5
				,
					name: "php (yii, kohana)"
					progress: 0.9
				,
					name: "phyton"
					progress: 0.25
				,
					name: "sql (mysql, postgress)"
					progress: 0.7
				,
					name: "nosql (mongodb)"
					progress: 0.4
				]

			"another":
				data: [
					name: "git"
					progress: 0.75
				,
					name: "linux"
					progress: 0.65
				,
					name: "os x"
					progress: 0.5
				]




	window.onscroll = ->
		portfolio.scrollController()
		skills.scrollController()

)()
