//#!/usr/bin/env node
// Load jessie
//var path   = require('path');
var sys   = require('util');
var fs     = require('fs');
//var lib    = path.join(path.dirname(fs.realpathSync(__filename)), 'node_modules/jessie/lib');
//require.paths.push(lib)
//require.paths.push(process.cwd() + '/spec')

var jessie = require('jessie');

// Load package.json
var pkgsrc  = fs.readFileSync(__dirname + '/node_modules/jessie/package.json');
var pkg     = JSON.parse(pkgsrc)

// Enable cli and set version name based on package.json
var cli  = require('cli').enable('version');
cli.setApp(pkg.name, pkg.version)

cli.setUsage('jessie [OPTIONS] [spec dirs/files]')

cli.parse({
  format: ['f', 'Output format to use', 'string', 'progress']
}, null);

process.on('uncaughtException', function (err) {
  var ansi = require('jessie/ansi')
  console.log(ansi.red + "Jessie failed to start. Here's some info about the problem:"+ansi.none)
  console.log(err.stack);
});

// Main loop
cli.main(function(args, options) {
  if (args.length == 0) {
    sys.puts(cli.getUsage())
    process.exit(1)
  }
  jessie.run(args, options, function(fail) {
    if (process.stdout.bufferSize > 0) {
      process.stdout.on('drain', function() {
        process.exit(fail ? 1 : 0)
      })
    } else {
      process.exit(fail ? 1 : 0)
    }

  })
})