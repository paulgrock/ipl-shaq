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
      poll.pollOptions = calculator.calculate poll
      poll.save (err)->
        vote = new Vote
          userId: userId
          votedFor: votedValue
          createdAt: Date.now()
          _poll: poll._id
        vote.save()

        cb()


    Poll.findOne({}).populate("votes").exec (err, poll)->
      console.log poll
      console.dir poll.toJSON()

    Vote.findOne({}).populate("_poll").exec (err, vote)->
      console.log vote
      console.dir vote.toJSON()


  incrementTotalFor: (votedValue, options)->
    for player in options when player.name is votedValue
      player.votes += 1
    return options

  update: (pollData, cb)->
    console.log pollData

module.exports = voteJobs
