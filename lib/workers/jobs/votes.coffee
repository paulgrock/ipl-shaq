mongoose = require 'mongoose'
pollSchema = require '../../mongo/schemas/polls'
Poll = mongoose.model 'Poll', pollSchema

calculator = require '../../payouts/calculator'

voteJobs =
  new: (pollData, userId, votedValue, cb)->
    Poll.findOne
      id: pollData.id
    , (err, poll)->
      return cb err if err?
      poll.pollOptions = voteJobs.incrementTotalFor votedValue, poll.pollOptions
      poll.total += 1
      poll.pollOptions = calculator.calculate poll.startsAt, poll.total, poll.pollOptions
      poll.votes.push
        userId: userId
        votedFor: votedValue
        createdAt: Date.now()
      poll.save cb

  incrementTotalFor: (votedValue, options)->
    for player in options when player.name is votedValue
      player.votes += 1
    return options

  update: (pollData, cb)->
    console.log pollData

module.exports = voteJobs