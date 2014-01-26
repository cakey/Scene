var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var gulp = require('gulp');
var gutil = require('gulp-util');
var sass = require('gulp-sass');
var serve = require('gulp-serve');
var http = require('http');
var ecstatic = require('ecstatic');
var jade = require('gulp-jade');
var clean = require('gulp-clean');

gulp.task('scripts', function() {  
    gulp.src(['src/**/*.coffee'])
        .pipe(concat("scene.js"))
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(gulp.dest('./public'))
});

gulp.task('styles', function(){
    gulp.src(['./src/**/*.scss'])
        .pipe(concat("scene.css"))
        .pipe(sass({errLogToConsole: true}))
        .pipe(gulp.dest('./public'))
});
gulp.task('jade', function(){
    gulp.src('./src/jade/index.jade')
        .pipe(jade().on('error', gutil.log))
        .pipe(gulp.dest('./public'))
});

gulp.task('clean', function() {
    gulp.src('./public', {read: false})
        .pipe(clean());
});

gulp.task('assets', function() {
    gulp.src('./src/assets/**/*')
        .pipe(gulp.dest('./public'))
});

gulp.task('default', ['scripts', 'styles', 'jade', 'assets'], function() {  

    http.createServer(
        ecstatic({ root: __dirname + '/public' })
    ).listen(8080);

    console.log('Listening on :8080');

    gulp.watch('src/**/*.coffee', ['scripts'])
    gulp.watch('src/**/*.scss', ['styles'])
    gulp.watch('src/**/*.jade', ['jade'])
    gulp.watch('src/assets/**/*', ['assets'])
});
