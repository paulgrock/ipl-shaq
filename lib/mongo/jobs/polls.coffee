mongoose = require 'mongoose'
pollSchema = require '../schemas/polls'
Poll = mongoose.model 'Poll', pollSchema

pollJobs =
  create: (pollData, cb)->
    poll = new Poll pollData
    poll.save (err, poll)->
      return cb err if err?
      cb()

  update: (pollData, cb)->
    Poll.findOneAndUpdate
      id: pollData.id
    , pollData
    , (err, poll)->
      return cb err if err?
      cb()

  stateChange: (pollData, cb)->
    Poll.findOne
      id: pollData.id
    , (err, poll)->
      return cb err if err?
      poll.state = pollData.state
      if pollData.state is "inactive" and !pollData.endsAt?
        pollData.endsAt = Date.now()
      poll.save cb

  delete: (pollId, cb)->
    Poll.findOneAndRemove
      id: pollId
    , (err, poll)->
      return cb err if err?
      cb()



module.exports = pollJobs