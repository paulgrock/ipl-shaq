mongoose = require 'mongoose'
Event = require '../../events/event'
pollSchema = require '../../mongo/schemas/polls'
Poll = mongoose.model 'Poll', pollSchema

pollJobs =
  create: (pollData, cb)->
    console.log pollData
    poll = new Poll pollData
    poll.save (err, poll)->
      return cb err if err?
      event = new Event pollData, "poll-start"
      #event.emit (err, response)->
      # return cb err if err?
      cb()

  update: (pollId, pollData, cb)->
    pollData = closePoll pollData if pollData.state is "inactive"
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

  closePoll: (pollData)->
    if pollData.endsAt is null or "null"
      pollData.endsAt = Date.now()
      return pollData


    event = new Event pollData, "poll-end"
    #event.emit()

    return pollData

  delete: (pollId, cb)->
    Poll.findOneAndRemove
      id: pollId
    , (err, poll)->
      return cb err if err?
      cb()



module.exports = pollJobs