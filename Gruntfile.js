module.exports = function(grunt) {

	// Configuration
	grunt.initConfig({
		// pass in options to plugins, references to files etc
		concat: {
			js: {
				src: ['src/main.js','src/directives/{,*/}*.js'],
				dest: 'dist/scripts.js'
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
					src: 'dist/scripts.js',
					dest: 'dist/scripts.js'
				}]
			}
		}
	});

	// Load plugins
	grunt.loadNpmTasks('grunt-contrib-concat');
	// grunt.loadNpmTasks('grunt-sass');
	grunt.loadNpmTasks('grunt-contrib-uglify');

	// Register tasks
	grunt.registerTask('concat-js', ['concat:js']);
	// grunt.registerTask('concat-css', ['concat:css']);

	grunt.registerTask('build', ['concat-js', 'uglify']);	

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