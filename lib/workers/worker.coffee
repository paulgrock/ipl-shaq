config = require '../../config'

class Worker
  constructor: (@type, options = {}) ->
    worker = require('coffee-resque').connect
      port: config.redis.client.port
      host: config.redis.client.url
    .worker @type, require "./jobs/#{@type}"
    worker.start()

module.exports = Worker