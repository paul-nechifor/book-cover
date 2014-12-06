async = require 'async'
fs = require 'fs'
path = require 'path'
{parseString} = require 'xml2js'

jsonify = (file, cb) ->
  fs.readFile file, {encoding: 'utf8'}, (err, xml) ->
    return cb err if err
    parseString xml, (err, result) ->
      return cb err if err
      parts = path.basename(file, '.svg').split '-'
      ornament =
        id: parts[0]
        width: Number result.svg.$.width
        height: Number result.svg.$.height
        d: result.svg.path[0].$.d
      if parts.length > 1
        ornament.tags = parts.slice(1).join ' '
      cb null, ornament

getOrnaments = (dir, cb) ->
  fs.readdir dir, (err, files) ->
    return cb err if err
    files = files.filter (f) -> f.indexOf('.svg') is f.length - 4
    files = files.map (f) -> dir + '/' + f
    async.map files, jsonify, cb

main = (cb) ->
  getOrnaments __dirname + '/../ornaments', (err, ornaments) ->
    return cb err if err
    js = "module.exports = #{JSON.stringify ornaments};"
    fs.writeFile __dirname + '/ornaments.js', js, cb

main (err) -> throw err if err
