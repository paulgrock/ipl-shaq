mongoose = require 'mongoose'
pollSchema = require '../../mongo/schemas/polls'
Poll = mongoose.model 'Poll', pollSchema

Event = require '../../events/event'
payouts = require '../../calculators/payout'
score = require '../../calculators/score'
accuracy = require '../../calculators/accuracy'

VoteTimer = require '../../rollingVotes/timer'

pollJobs =
  create: (pollData, cb)->
    poll = new Poll pollData

    for option in poll.pollOptions
      option.payout = payouts.calculate poll, option.votes

    VoteTimer.start poll

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
    event = new Event pollData, "poll-end"
    #event.emit()

    if pollData.endsAt is null or "null"
      pollData.endsAt = Date.now()

    score.calculate poll
    #calculateScore
    #calculateAccuracy

    return pollData

  delete: (pollId, cb)->
    Poll.findOneAndRemove
      id: pollId
    , (err, poll)->
      return cb err if err?
      cb()

module.exports = pollJobs