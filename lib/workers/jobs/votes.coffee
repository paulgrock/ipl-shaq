Poll = require '../../mongo/schemas/polls'
User = require '../../mongo/schemas/users'
UserStats = require '../../mongo/schemas/stats/users'
Vote = require '../../mongo/schemas/votes'
VoteSummary = require '../../mongo/schemas/voteSummary'

payouts = require '../../calculators/payout'
score = require '../../calculators/score'
VoteTimer = require '../../rollingVotes/timer'

voteJobs =
  new: (pollData, userId, votedValue, cb)->
    Poll.findOne
      id: pollData.id
    , (err, poll)->
      return cb err if err?

      userPayout = 0
      for option in poll.pollOptions when option.name is votedValue
        userPayout = payouts.calculate poll, option.votes

      poll.pollOptions = voteJobs.incrementTotalFor votedValue, poll.pollOptions
      poll.total += 1

      for option in poll.pollOptions
        option.payout = payouts.calculate poll, option.votes

      User.findOne
        id: userId
      .lean()
      .exec (err, user)->
        vote = new Vote
          _user: user._id
          votedFor: votedValue
          createdAt: Date.now()
          _poll: poll._id
        vote.save()

        VoteSummary.findOneAndUpdate
          _user: user._id
          _poll: poll._id
        ,
          votedFor: votedValue
          payout: userPayout
          $inc:
            count: 1
        ,
          upsert: true
        , (err, doc)->
          poll.voteSummary.addToSet doc._id
          poll.votes.push vote._id
          voteTimer = new VoteTimer poll
          voteTimer.updateRollingVoteCount (err, rollingVotes)->
            rollingTotal = rollingVotes.total
            for option in poll.pollOptions
              option.rollingVotes = rollingVotes[option.name]

            poll.save (err)->
              cb()

  incrementTotalFor: (votedValue, options)->
    for player in options when player.name is votedValue
      player.votes += 1
    return options

module.exports = voteJobs
