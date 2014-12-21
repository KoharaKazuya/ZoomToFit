gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
del        = require 'del'
coffeelint = require 'gulp-coffeelint'

gulp.task 'default', ['compile']

gulp.task 'compile', ['copy', 'coffee']

gulp.task 'clean', del.bind(null, ['./build'])

gulp.task 'test', ['lint']

gulp.task 'watch', ->
  gulp.watch './src/**/*', [
    'compile'
    'test'
  ]

gulp.task 'coffee', ->
  gulp.src './src/coffee/**/*.coffee'
    .pipe coffee({ bare: true })
    .pipe gulp.dest('./build/')

gulp.task 'copy', ->
  gulp.src [
    './src/manifest.json'
    './src/image/**/*'
    './src/html/**/*'
    './src/css/**/*'
  ]
    .pipe gulp.dest('./build/')

gulp.task 'lint', ->
  gulp.src './src/coffee/**/*.coffee'
    .pipe coffeelint()
    .pipe coffeelint.reporter()
