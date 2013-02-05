mongoose = require 'mongoose'

pollSchema = require '../../mongo/schemas/polls'
userSchema = require '../../mongo/schemas/users'
voteSchema = require '../../mongo/schemas/votes'
voteSummarySchema = require '../../mongo/schemas/voteSummary'

Poll = mongoose.model 'Poll', pollSchema
Vote = mongoose.model 'Vote', voteSchema
User = mongoose.model 'User', userSchema
VoteSummary = mongoose.model 'VoteSummary', voteSummarySchema

payouts = require '../../calculators/payout'
score = require '../../calculators/score'
VoteTimer = require '../../rollingVotes/timer'

voteJobs =
  new: (pollData, userId, votedValue, cb)->
    Poll.findOne
      id: pollData.id
    , (err, poll)->
      return cb err if err?
      poll.pollOptions = voteJobs.incrementTotalFor votedValue, poll.pollOptions
      poll.total += 1

      userPayout = 0

      for option in poll.pollOptions
        if option.name is votedValue
          userPayout = payouts.calculate poll, option.votes
        option.payout = payouts.calculate poll, option.votes

      User.findOne
        id: userId
      , lean: true
      , (err, user)->
        vote = new Vote
          _user: user._id
          votedFor: votedValue
          createdAt: Date.now()
          _poll: poll._id
        vote.save()

        VoteSummary.findOne
          _user: user._id
          _poll: poll._id
        , (err, doc)->
          if doc?
            doc.votedFor = votedValue
            doc.payout = userPayout
            doc.count += 1
            doc.save()
          else
            voteSummary = new VoteSummary
              _user: user._id
              votedFor: votedValue
              payout: userPayout
              count: 1
              _poll: poll._id
            voteSummary.save (err, doc)->
              poll.voteSummary.push voteSummary._id

          poll.votes.push vote._id
          voteTimer = new VoteTimer poll
          voteTimer.updateRollingVoteCount (err, rollingVotes)->
            rollingTotal = rollingVotes.total
            for option in poll.pollOptions
              option.rollingVotes = rollingVotes[option.name]

            poll.save (err)->
              cb()


      score.calculate poll

  incrementTotalFor: (votedValue, options)->
    for player in options when player.name is votedValue
      player.votes += 1
    return options

  update: (pollData, cb)->
    console.log pollData

module.exports = voteJobs
