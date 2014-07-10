gulp = require 'gulp'
chalk = require 'chalk'
gbump = require 'gulp-bump'
coffee = require 'gulp-coffee'

yargs = require 'yargs'
  .wrap 80
  .alias 'h', 'help'
  .describe 'help', 'Show this help information.'
  .check (argv) -> if argv.help then throw new Error 'Help!'


log = (plugin, msg) -> console.log chalk.reset("[#{chalk.green plugin}]"), msg
log.warn = (plugin, msg) -> console.warn chalk.reset("[#{chalk.yellow plugin}]"), msg
log.error = (plugin, error) ->
  prefix = chalk.reset "[#{chalk.red plugin}]"
  if error.stack
    console.error prefix, line for line in error.stack.split '\n'
  else console.error prefix, error.message or error


gulp.task 'build', ->
  gulp.src './src/ReactComponentPlugin.coffee'
    .pipe coffee bare: true
    .on 'error', (error) ->
      log.error 'coffee', error
      @end()
    .pipe gulp.dest '.'


gulp.task 'bump', ->
  argv = yargs
    .usage '''

           Bump the package version.

           With no options, bumps to the next patch version.

           Usage: gulp bump [--major|--minor|--patch|--to x.x.x]
           '''
    .options
      major:
        describe: 'Bump the package to the next major version (1.x.x to 2.0.0)'
      minor:
        describe: 'Bump the package to the next minor version (1.0.x to 1.1.0)'
      patch:
        describe: 'Bump the package to the next patch version (1.0.0 to 1.0.1)'
      to:
        describe: 'Bump the package to the specified version'
    .check (argv) ->
      if argv.major and argv.minor
        throw new Error 'Cannot specify both major and minor'
      else if argv.major and argv.patch
        throw new Error 'Cannot specify both major and patch'
      else if argv.major and argv.to
        throw new Error 'Cannot specify both major and version'
      else if argv.minor and argv.patch
        throw new Error 'Cannot specify both minor and patch'
      else if argv.minor and argv.to
        throw new Error 'Cannot specify both minor and version'
      else if argv.patch and argv.to
        throw new Error 'Cannot specify both patch and version'
    .argv

  opts =
    if argv.to
      version: argv.to
    else if argv.major
      type: 'major'
    else if argv.minor
      type: 'minor'
    else
      type: 'patch'

  gulp.src ['./bower.json', './package.json']
    .pipe gbump opts
    .pipe gulp.dest './'


gulp.task 'test', ->
  throw new Error 'no tests yet!'


gulp.task 'watch', ->
  gulp.watch './src/**/*.?(lit)coffee', ['build']
