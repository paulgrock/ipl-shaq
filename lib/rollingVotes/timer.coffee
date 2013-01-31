mongoose = require 'mongoose'
voteSchema = require '../mongo/schemas/votes'
Vote = mongoose.model 'Vote', voteSchema

class VoteTimer
  constructor: (@poll, options = {}) ->

  getTimeWindow: ->
    voteWindow = 5 #minutes
    return new Date().setMinutes new Date().getMinutes() - voteWindow

  updateRollingVoteCount: (cb)->
    timeAgo = @getTimeWindow()
    Vote.find
      _poll: @poll._id
    .where("createdAt").gte(timeAgo)
    .exec (err, docs)=>
      return cb err if err? and cb?
      votes =
        total: docs.length

      for option in @poll.pollOptions
        votes[option.name] = 0

      for doc in docs
        votes[doc.votedFor] += 1

      cb null, votes if cb?

  @start: (poll)->
    voteTimer = new VoteTimer poll
    setInterval ->
      voteTimer.updateRollingVoteCount()
    , 3000


module.exports = VoteTimer
