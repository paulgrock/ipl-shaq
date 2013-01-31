mongoose = require 'mongoose'

pollSchema = require '../mongo/schemas/polls'
voteSchema = require '../mongo/schemas/votes'
userSchema = require '../mongo/schemas/users'
pollSummarySchema = require '../mongo/schemas/summaries/polls'
voteSummarySchema = require '../mongo/schemas/voteSummary'

Poll = mongoose.model 'Poll', pollSchema
Vote = mongoose.model 'Vote', voteSchema
User = mongoose.model 'User', userSchema
PollSummary = mongoose.model 'PollSummary', pollSummarySchema

VoteSummary = mongoose.model 'VoteSummary', voteSummarySchema

score =
  calculate: (poll)->
    winner = "TubbyTheFat" #poll.matchup.game.winner

    VoteSummary.find
       _poll: poll._id
    .where("votedFor").equals(winner)
    .sort("-payout")
    .populate("User")
    .exec (err, docs)->
      Poll.findById poll._id, (err, poll)->
        for summary, index in docs
          pollSummary = new PollSummary
            _poll: poll._id
            _user: summary._user._id
            score: summary.payout
          pollSummary.save()
          poll.scores.push pollSummary
          poll.save()

    return score

module.exports = score
