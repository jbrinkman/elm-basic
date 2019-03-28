const
    gulp = require("gulp"),
    pug = require('gulp-pug'),
    del = require("del"),
    elm = require('gulp-elm'),
    browserSync = require('browser-sync').create();

let paths = {
    dist: "dist",
    pug: "src/**/*.pug",
    pugMain: ['src/index.pug'],
    static: "src/static/**/*.*",
    copy: ['src/index.html', 'src/**/*.js', 'src/static/**/*.*'],
    elm: "src/**/*.elm",
    elmMain: "src/Main.elm"
};

function clean(cb) {
    return del(['./dist/*']).then(() => cb());
}

function pugCompile(cb) {
    return gulp.src(paths.pugMain)
        .pipe(pug({ pretty: true }))
        .pipe(gulp.dest(paths.dist));
}

function copy(cb) {
    return gulp.src(paths.copy, { allowEmpty: true })
        .pipe(gulp.dest(paths.dist));
}

function elmCompile(cb) {
    return gulp.src(paths.elmMain)
        .pipe(elm({ "debug": true }))
        .pipe(gulp.dest(paths.dist));
}

function watch(done) {
    browserSync.init({
        server: {
            baseDir: "./dist"
        }
    });
    console.log("Listening on port 3000");

    gulp.watch(paths.pug, gulp.series(pugCompile));
    gulp.watch(paths.elm, gulp.series(elmCompile));
    gulp.watch(paths.static, gulp.series(copy));
    gulp.watch(paths.dist + "/**/*.{js,html,css}").on('change', browserSync.reload);
    done();
}

exports.build = gulp.series(clean, pugCompile, copy, elmCompile);
exports.watch = gulp.series(clean, pugCompile, copy, elmCompile, watch);
exports.default = gulp.series(clean, pugCompile, copy, elmCompile, watch);
