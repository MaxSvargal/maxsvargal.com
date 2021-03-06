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
					# Set to false for faster compiling
					force: false
					debugInfo: false
					relativeAssets: false
					require: ['animation']
			prod:
				options:
					sassDir: 'src/styles'
					cssDir: 'public/styles'
					environment: 'production'
					require: ['animation']

		jade:
			index:
				options:
					client: false
				files:
					'public': 'src/index.jade'
					
		urequire:
			dev:
				template: 'combined'
				bundlePath: 'src/scripts/'
				main: 'main'
				outputPath: 'public/scripts/main.js'
				debugLevel: 3
			prod:
				template: 'combined'
				bundlePath: 'src/scripts/'
				main: 'main'
				outputPath: 'public/scripts/main.js'
				optimize: 'uglify2'	

		copy:
			img:
				expand: true
				cwd: 'src/images'
				src: '**'
				dest: 'public/images'
			fonts:
				expand: true
				cwd: 'src/fonts'
				src: '**'
				dest: 'public/fonts'

		connect:
			dev:
				options:
					port: 9000
					base: 'public'
					middleware: (connect, options) -> [
						require('connect-url-rewrite') ['^([^.]+|.*\\?{3}.*)$ /']
						connect.static options.base
						connect.directory options.base
					]
		
		watch:
			options:
				livereload: true

			jade: 
				files: 'src/templates/**/*.jade'
				tasks: 'jade:compile'
				options:
					interrupt: true

			index:
				files: 'src/*.jade'
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
				tasks: 'urequire:dev'
				options:
					interrupt: true
	# Dependencies
	# ============
	for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
		grunt.loadNpmTasks name

	# Default task(s).
	grunt.registerTask 'dev', [
		'urequire:dev'
		'jade:index'
		'connect:dev'
		'compass:dev'
		'watch'
	]

	grunt.registerTask 'prod', [
		'urequire:prod'
		'jade:index'
		'compass:prod'
		'copy:img'
		'copy:fonts'
	]

	grunt.registerTask 'default', 'dev'
