
module.exports = (grunt) ->
  grunt.initConfig 
    imagemin: # Task
      options: 
        optimizationLevel: 3

      dynamic: 
        files: [
          expand: true 
          cwd: "public/uploads" 
          src: ["*.{png,jpg,gif}"] 
          dest: "public/uploads2/"
          rename: (dest,src) ->
            return dest + src
        ]

  grunt.loadNpmTasks "grunt-contrib-imagemin"
  grunt.registerTask "default", ["imagemin"]