'use strict';

const gulp = require('gulp');
const parallel = require('concurrent-transform');
const os = require('os');
const changed = require('gulp-changed');
const imageResize = require('gulp-image-resize');
const imageMin = require('gulp-imagemin');
const png = require('imagemin-pngquant');
const jpeg = require('imagemin-jpeg-recompress');

gulp.task('resize', function () {
  return gulp.src('src/*')
    .pipe(changed('t_post'))
    .pipe(resize({
      width: 720,
      height: 480
    }))
    .pipe(moderateImageMin())
    .pipe(gulp.dest('t_post'))
    .pipe(resize({
      width: 720,
      height: 70
    }))
    .pipe(harshImageMin())
    .pipe(gulp.dest('t_list'));
});

function moderateImageMin() {
  return parallel(
    imageMin([
      imageMin.gifsicle(),
      jpeg({ method: 'smallfry', min: 60 }),
      png(),
      imageMin.optipng(),
      imageMin.svgo()
    ]),
    os.cpus().length
  );
}

function harshImageMin() {
  return parallel(
    imageMin([
      imageMin.gifsicle(),
      jpeg({ quality: 'low', method: 'smallfry', min: 50 }),
      png(),
      imageMin.optipng(),
      imageMin.svgo()
    ]),
    os.cpus().length
  );
}

function resize(options) {
  return parallel(
    imageResize(Object.assign({
      gravity: 'Center',
      filter: 'catrom',
      crop: true,
      imageMagick: true
    }, options)),
    os.cpus().length
  );
}