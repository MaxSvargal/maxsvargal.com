module.exports = (grunt) ->
	'use strict'

	pkg = require './package.json'

	grunt.initConfig 
		compass: 
			dev: 
				options:
					sassDir: 'src/styles'
					cssDir: 'public/styles'
					imagesDir: 'src/images'
					generatedImagesDir: 'public/images/'
					httpImagesPath: '../images'
					javascriptsDir: 'public/scripts'
					force: true
					debugInfo: true
					relativeAssets: false
		jade: 
			compile:
				options:
					debug: false
					client: true
					pretty: false
					self: false
					locals: true
					runtime: false
					wrap:
						amd: true
						dependencies: 'jade'
				files:
					'public/scripts/templates/': ['src/templates/**/*.jade']
			index:
				options:
					client: false
				files:
					'public': 'src/index.jade'
		urequire:
			combine:
				template: 'combined'
				bundlePath: 'src/scripts/'
				main: 'main'
				outputPath: 'public/scripts/main.js'
				#optimize: 'uglify2'
		connect:
			dev:
				options:
					port: 9000
					base: 'public'

		watch:
			jade: 
				files: 'src/templates/**/*.jade'
				tasks: 'jade:compile'
				options:
					interrupt: true

			index:
				files: 'src/index.jade'
				tasks: 'jade:index'
				options:
					interrupt: true

			compass: 
				files: 'src/styles/*.sass'
				tasks: 'compass:dev'
				options:
					interrupt: true

			urequire:
				files: 'src/scripts/**/*.coffee'
				tasks: 'urequire:combine'
				options:
					interrupt: true
	# Dependencies
	# ============
	for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
		grunt.loadNpmTasks name

	# Default task(s).
	grunt.registerTask 'server', [
		'urequire:combine'
		'jade:compile'
		'jade:index'
		'connect:dev'
		'compass:dev'
		'watch'
	]

	grunt.registerTask 'default', 'server'
