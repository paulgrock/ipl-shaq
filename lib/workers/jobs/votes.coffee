mongoose = require 'mongoose'
pollSchema = require '../../mongo/schemas/polls'
voteSchema = require '../../mongo/schemas/votes'
Poll = mongoose.model 'Poll', pollSchema
Vote = mongoose.model 'Vote', voteSchema

calculator = require '../../payouts/calculator'

voteJobs =
  new: (pollData, userId, votedValue, cb)->
    Poll.findOne
      id: pollData.id
    , (err, poll)->
      return cb err if err?
      poll.pollOptions = voteJobs.incrementTotalFor votedValue, poll.pollOptions
      poll.total += 1

      for option in poll.pollOptions
        option.payout = calculator.calculate poll, option.votes

      vote = new Vote
        userId: userId
        votedFor: votedValue
        createdAt: Date.now()
        _poll: poll._id
      vote.save()

      poll.votes.push vote._id

      poll.save (err)->
        cb()

  incrementTotalFor: (votedValue, options)->
    for player in options when player.name is votedValue
      player.votes += 1
    return options

  update: (pollData, cb)->
    console.log pollData

module.exports = voteJobs
