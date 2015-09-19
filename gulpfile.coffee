del        = require 'del'
gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
zip        = require 'gulp-zip'

gulp.task 'default', ['compile']

gulp.task 'compile', ['copy', 'coffee']

gulp.task 'clean', del.bind(null, ['./build', './dist'])

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

gulp.task 'dist', ['compile'], ->
  gulp.src './build/**/*'
    .pipe zip('ZoomToFit.zip')
    .pipe gulp.dest('./dist/')
