Poll = require '../../mongo/schemas/polls'
Competition = require '../../mongo/schemas/competitions'

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

    Competition.findOneAndUpdate
      id: poll.matchup.id
    ,
      id: poll.matchup.id
      status: "active"
      title: "#{poll.pollOptions[0].name} vs #{poll.pollOptions[1].name}"
      startsAt: Date.now()
    , upsert: true
    , (err, competition)->
      competition.polls.push poll._id
      competition.save()

      poll.competition = competition._id
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
    #calculateAccuracy

    return pollData

  delete: (pollId, cb)->
    Poll.findOneAndRemove
      id: pollId
    , (err, poll)->
      return cb err if err?
      cb()

module.exports = pollJobs
