mongoose = require 'mongoose'

pollSchema = require '../mongo/schemas/polls'
competitionSchema = require '../mongo/schemas/competitions'
pollSummarySchema = require '../mongo/schemas/summaries/polls'
competitionSummarySchema = require '../mongo/schemas/summaries/competitions'
voteSummarySchema = require '../mongo/schemas/voteSummary'

Poll = mongoose.model 'Poll', pollSchema
Competition = mongoose.model 'Competition', competitionSchema
PollSummary = mongoose.model 'PollSummary', pollSummarySchema
CompetitionSummary = mongoose.model 'competitionSummary', competitionSummarySchema
VoteSummary = mongoose.model 'VoteSummary', voteSummarySchema

score =
  calculate: (poll)->
    winner = "TubbyTheFat" #poll.matchup.game.winner

    mapReduce =
      map: -> emit this._user, this.score
      reduce: (key, vals)-> return Array.sum vals

    VoteSummary.find
       _poll: poll._id
    .where("votedFor").equals(winner)
    .exec (err, docs)->
      Poll.findById poll._id, (err, poll)->
        for summary in docs
          pollSummary = new PollSummary
            _poll: poll._id
            _user: summary._user
            score: summary.payout
          pollSummary.save()
          poll.scores.push pollSummary
          poll.save()
        Competition.findById poll.competition, (err, competition)->
          PollSummary
          .find()
          .where("_poll").in(competition.polls)
          .exec (err, scoresummaries)->
            for scoresummary in scoresummaries
              CompetitionSummary.findOne
                "_competition": competition._id
              .where("_user").equals(scoresummary._user)
              .exec (err, competitionSummary)->
                if competitionSummary?
                  competitionSummary.score += scoresummary.score
                  competitionSummary.save()
                else
                  cs = new CompetitionSummary
                    _user: scoresummary._user
                    score: scoresummary.score
                  cs.set _competition: competition
                  cs.save()
                  competition.scores.push cs
                  competition.save()

module.exports = score
