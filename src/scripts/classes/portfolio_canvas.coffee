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
			# After looping on all images event is set to last - classic closure problem.
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

module.exports = portfolioCanvas
