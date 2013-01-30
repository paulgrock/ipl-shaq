request = require 'request'
config = require '../../config'

class Emitter
  constructor: (poll, @type, options = {}) ->
    @pollId = poll.id
    @streamId = poll.stream.id

  emit: (cb)->
    request "#{config.dundee.url}cue-point-type=poll&poll-type=#{@type}&poll-id=#{@pollId}&streamid=#{@streamId}", (err, res, body)->
      return cb err if err?
      if res.statusCode is 200
        return cb null, true
      else
        return cb null, false

module.exports = Emitter