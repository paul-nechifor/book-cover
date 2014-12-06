exports.Ornament = class Ornament
  constructor: (opts) ->
    {@id, @width, @height, @d} = opts
    @tags = {}
    if opts.tags
      @tags[t] = true for t in opts.tags.split ' '

exports.OrnamentSet = class OrnamentSet
  constructor: (list) ->
    @list =
      for o in list
        new Ornament o

exports.Cover = class Cover
  constructor: (@builder, @info) ->
    @$ = @builder.$
    @width = @info.width or 450
    @height = @info.height or 600
    @el = null

  generate: ->
    @el = @$ '<svg/>'
    .attr
      xmlns: 'http://www.w3.org/2000/svg'
      width: @width
      height: @height

    text = @$ '<text/>'
    .attr
      x: 0
      y: @height / 2
    .text @info.title + ' by ' + @info.author
    @el.append text
    @

  save: (name, cb) ->
    data = '<?xml version="1.0" standalone="no"?>' + @$.xml @el
    @builder.fs.writeFile name, data, {encoding: 'utf8'}, cb

exports.CoverBuilder = class CoverBuilder
  constructor: (isNode) ->
    if isNode
      @fs = require 'fs'
      @$ = require('cheerio').load '<html><body></body></html>'
    else
      @$ = $
    @ornaments = new OrnamentSet require './ornaments'

  newCover: (opts) ->
    new Cover @, opts
