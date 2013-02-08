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

  stateChange: (pollData, cb)->
    Poll.findOne
      id: pollData.id
    , (err, poll)->
      return cb err if err?
      poll.state = pollData.state
      if pollData.state is "inactive" and !pollData.endsAt?
        pollData.endsAt = Date.now()
      poll.save cb

  closePoll: (poll)->
    event = new Event poll, "poll-end"
    #event.emit()

    if poll.endsAt is null or "null"
      poll.endsAt = Date.now()
      poll.save()

    score.calculate poll
    return poll

  update: (pollId, pollData, cb)->
    Poll.findOneAndUpdate
      id: pollId
    , pollData
    , (err, poll)->
      return cb err if err?
      pollJobs.closePoll poll if pollData.state is "inactive"
      cb()

  delete: (pollId, cb)->
    Poll.findOneAndRemove
      id: pollId
    , (err, poll)->
      return cb err if err?
      cb()

module.exports = pollJobs
