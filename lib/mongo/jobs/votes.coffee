mongoose = require 'mongoose'
pollSchema = require '../schemas/polls'
Poll = mongoose.model 'Poll', pollSchema

voteJobs =
  new: (pollData, votedValue, cb)=>
    Poll.findOne
      id: pollData.id
    , (err, poll)->
      return cb err if err?
      options = voteJobs.incrementTotalFor votedValue, poll.pollOptions
      poll.pollOptions = options
      poll.total += 1
      console.log poll
      poll.save cb

  incrementTotalFor: (votedValue, options)->
    for player in options when player.name is votedValue
      player.votes += 1

    return options

  update: (pollData, cb)->
    console.log pollData

module.exports = voteJobs