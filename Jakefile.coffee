#!node_modules/.bin/jake

peg = require 'pegjs'
jsp = require("uglify-js").parser
pro = require("uglify-js").uglify
coffee  = require 'coffee-script'
fs      = require 'fs'
path    = require 'path'
pkgJSON = JSON.parse fs.readFileSync path.join(__dirname, 'package.json'), 'utf-8'

files = [
  'index.js', 'parser.js', 'package.json'
]
  
new jake.PackageTask pkgJSON.name, pkgJSON.version, ->
  @packageFiles.include files
  @needTarGz = true

new jake.NpmPublishTask pkgJSON.name, files

file 'parser.js', ['parser.peg'], ->
  console.log "Compiling parser"
  fs.writeFileSync 'parser.js', "module.exports = "+
    peg.buildParser(fs.readFileSync('parser.peg').toString()).toSource()

tests = new jake.FileList()
tests.include 'test/*.coffee'
tests = tests.toArray()

task 'test', tests.concat(files), (->
  cmd = ['node_modules/.bin/mocha'].concat tests
  exec = jake.createExec [cmd.join(' ')], printStdout: true
  exec.addListener 'stderr', (data)-> process.stderr.write data
  exec.addListener 'error', (msg, code)-> if code == 0 then complete() else fail()
  exec.run()
 ), async: true
  

task 'default', files.concat ['test']

if process.argv.length == 3 && process.argv[2] == './Jakefile.coffee'
  jake.Task['default'].invoke()

