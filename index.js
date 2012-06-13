#!/usr/bin/env node

var fs = require('fs')
  , path = require('path')
  , program = require('commander')
  , parser = require('./parser.js')
  , sep = "\n"
  , pkg = JSON.parse(fs.readFileSync(path.join(__dirname, 'package.json')))

program
  .version(pkg.version)
  .usage('[options] prefix <file.css ...>' +
         "\n\n `prefix` can be any valid css selector, like a class or id.")
  .option('-j --join', 'Dont separate rules by new-line')
  .option('-D --no-directives', 'Dont output css directives: @import, @face, etc')
  .parse(process.argv)

if (program.join) sep = ""

if (program.args.length < 2) {
  process.stderr.write(program.helpInformation())
  process.exit(1)
}

var i, rules = [], prefix = program.args[0]

for (i = 1; i < program.args.length; i++) {
  var file = program.args[i]
    , code = fs.readFileSync(file).toString()
    , parsed  = parser.parse(code)
  if(!parsed) {
    throw("Could not parse "+file)
  }
  rules = rules.concat(parsed)
}

var printRules = function(rules) {
  for (var i = 0; i < rules.length; i++){
    var rule = rules[i]
      , selectors = []
    if (rule.directive && program.directives) {
      process.stdout.write(''+rule.directive+rule.body+sep)
    } else if (rule.media) {
      process.stdout.write(rule.media+"{"+sep)
      printRules(rule.rules)
      process.stdout.write("}"+sep)
    } else if (rule.selectors) {
      for (var s = 0; s < rule.selectors.length; s++){
        selectors.push(prefix + " " + rule.selectors[s])
      }
      process.stdout.write(selectors.join(", ")+rule.body+sep)
    }
  }
}

printRules(rules)
