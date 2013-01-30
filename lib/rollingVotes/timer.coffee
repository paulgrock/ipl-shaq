mongoose = require 'mongoose'
voteSchema = require '../mongo/schemas/votes'
Vote = mongoose.model 'Vote', voteSchema

class Timer
  constructor: (@poll, options = {}) ->

  getTimeWindow: ->
    voteWindow = 5 #minutes
    return new Date().setMinutes new Date().getMinutes() - voteWindow

  start: ()->
    setInterval =>
      @updateRollingVoteCount()
    , 3000

  updateRollingVoteCount: (cb)->
    timeAgo = @getTimeWindow()
    Vote.find
      _poll: @poll._id
    .where("createdAt").gte(timeAgo)
    .exec (err, docs)=>
      return cb err if err?
      votes =
        total: docs.length

      for option in @poll.pollOptions
        votes[option.name] = 0

      for doc in docs
        votes[doc.votedFor] += 1

      cb null, votes


module.exports = Timer
