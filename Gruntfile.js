module.exports = function(grunt) {

	// Configuration
	grunt.initConfig({
		// pass in options to plugins, references to files etc
		concat: {
			js: {
				src: ['src/main.js','src/directives/{,*/}*.js'],
				dest: 'build/scripts.js'
			}
			// ,
			// css: {
			// 	src: ['css/reset.css', 'css/bootstrap.css', 'styles.css'],
			// 	dest: 'build/styles.css'
			// }
		},

		// sass: {
		// 	build: {
		// 		files: [{
		// 			src: 'css/sass/styles.scss',
		// 			dest: 'css/styles.css'
		// 		}]
		// 	}
		// },

		uglify: {
			build: {
				files: [{
					src: 'build/scripts.js',
					dest: 'build/scripts.js'
				}]
			}
		},

		clean: {
			build: {
				files: [{
					dot: true,
					src: [
						'build/{,*/}*'
					]
				}]
			},
			dist: {
				files: [{
					dot: true,
					src: [
						'src/dist/{,*/}*'
					]
				}]
			}
		},

		copy: {
			dist: {
				files: [{
						expand: true,
						cwd: 'build',
						src: '{,*/}*.*',
						dest: 'src/dist'
					}, {
						expand: true,
						cwd: 'src',
						src: 'directives/{,*/}*.html',
						dest: 'src/dist'
					}
				]
			}
		}
	});

	// Load plugins
	grunt.loadNpmTasks('grunt-contrib-concat');
	// grunt.loadNpmTasks('grunt-sass');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-copy');

	// Register tasks
	grunt.registerTask('concat-js', ['concat:js']);
	// grunt.registerTask('concat-css', ['concat:css']);

	grunt.registerTask('build', ['clean:build','concat-js', 'uglify']);	
	grunt.registerTask('dist', ['clean:dist','copy:dist']);
	grunt.registerTask('prod', ['build','dist']);

/*
	grunt.registerTask('run', function(){
		console.log('I am running')
	});

	grunt.registerTask('sleep', function(){
		console.log('I am sleepping')
	});

	grunt.registerTask('all', ['sleep', 'run']);
*/
};