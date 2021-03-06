'use strict'

module.exports = class skillsBars
	constructor: (@config) ->
		@bar_width = 300
		header = document.getElementById "header"
		@start = header.scrollHeight - window.innerHeight + 220
		for name, group of @config
			@createDom name, group

	getAbilityLevel: (progress) ->
		switch
			when progress <= 0.3 then "basic"
			when progress <= 0.6 then "intermediate"
			when progress <= 0.8 then "advanced"
			when progress <= 1 then "good"
			else "excellent"

	createDom: (name, group) ->
		container = document.getElementById 'skills'
		cgroup = document.createElement 'div'

		for bname, data of group
			cgroup = document.getElementById name
			if not cgroup
				throw new Error "Cannot create skills group with id ##{name}"
			cgroup.className = "group #{name}"

			for item in data
				box = document.createElement 'div'
				box.className = "box"

				label = document.createElement 'label'
				label.className = "label"
				label.innerHTML = item.name

				bar = document.createElement 'div'
				bar.className = "bar #{name}"
				bar.dataset.width = @bar_width * item.progress

				bar_label = document.createElement 'span'
				bar_label.innerHTML = @getAbilityLevel item.progress
				
				bar.appendChild bar_label
				box.appendChild label
				box.appendChild bar
				cgroup.appendChild box

	animateBars: (name) ->
		group = document.getElementById name
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

		animate
			delay: 10
			duration: 1600
			delta: (progress) ->
				Math.pow progress, 4
			step: (delta) ->
				for el in elems
					do (el) ->
						bar = el.getElementsByClassName 'bar'
						label = el.getElementsByTagName 'span'
						bar[0].style.width = bar[0].dataset.width * delta + 'px'
						label[0].style.opacity = delta

	scrollController: (obj) ->
		p_offset = obj.pageYOffset or obj.scrollTop

		i = 0
		if p_offset >= @start and p_offset <= 1828
			for name, obj of @config
				if p_offset >= @start + 450 * i
					@animateBars name
				i++
