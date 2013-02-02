express = require 'express'
http = require 'http'
path = require 'path'
redis = require 'redis'
config = require './config'
mongoose = require 'mongoose'
Worker = require './lib/workers/worker'

app = express()

mongoose.connect config.mongo.url, config.mongo.name

app.configure 'production', ->
  app.set "port", process.env.PORT || 80
  config = require './configProd'

app.configure ->
  app.set 'port', process.env.PORT || 3007
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
  app.use express.errorHandler()

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port " + app.get('port')

new Worker "polls"
new Worker "votes"
new Worker "users"
