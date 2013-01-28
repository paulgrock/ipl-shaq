express = require 'express'
routes = require './routes'
user = require './routes/user'
http = require 'http'
path = require 'path'
redis = require 'redis'
config = require './config'
mongoose = require 'mongoose'
pollJobs = require './lib/mongo/jobs/polls'
voteJobs = require './lib/mongo/jobs/votes'

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

app.get '/', routes.index
app.get '/users', user.list

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port " + app.get('port')

pollWorker = require('coffee-resque').connect
  port: config.redis.client.port
  host: config.redis.client.url
.worker "polls", pollJobs

voteWorker = require('coffee-resque').connect
  port: config.redis.client.port
  host: config.redis.client.url
.worker "votes", voteJobs

pollWorker.start()
voteWorker.start()

db = mongoose.connection
db.once 'open', ->
  console.log "connected to mongo"