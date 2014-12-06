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
    @width = @info.width or 450
    @height = @info.height or 600
    @el = null

  generate: ->
    @el = @builder.doc.createElement 'svg'
    @el.setAttribute 'xmlns', 'http://www.w3.org/2000/svg'
    @el.setAttribute 'width', @width
    @el.setAttribute 'height', @height

    text = @builder.newEl @el, 'text'
    text.setAttribute 'x', 0
    text.setAttribute 'y', 0
    text.innerHTML = @info.title + ' by ' + @info.author
    @

  intoElement: (parent) ->
    parent.appendChild @el
    @

  intoFile: (name, cb) ->
    top = @builder.doc.body
    @intoElement top
    data = '<?xml version="1.0" standalone="no"?>' + top.innerHTML
    @builder.fs.writeFile name, data, {encoding: 'utf8'}, cb

exports.CoverBuilder = class CoverBuilder
  constructor: (isNode) ->
    if isNode
      @fs = require 'fs'
      @window = require('jsdom').jsdom().parentWindow
    else
      @window = window
    @doc = @window.document
    @ornaments = new OrnamentSet require './ornaments'

  newCover: (opts) ->
    new Cover @, opts

  newEl: (parent, type) ->
    el = @doc.createElement type
    parent.appendChild el
    el
