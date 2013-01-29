request = require 'request'

class Emitter
  constructor: (@type, options = {}) ->

  emit: ->
    request.post "#{dundeeUrl}", @type

module.exports = Emitter