Poll = require '../mongo/schemas/polls'
PollSummary = require '../mongo/schemas/summaries/polls'
Competition = require '../mongo/schemas/competitions'
CompetitionSummary = require '../mongo/schemas/summaries/competitions'

UserStats = require '../mongo/schemas/stats/users'
VoteSummary = require '../mongo/schemas/voteSummary'

score =
  calculate: (poll)->
    winner = "TubbyTheFat" #poll.matchup.game.winner

    VoteSummary.find
       _poll: poll._id
    .where("votedFor").equals(winner)
    .lean()
    .exec (err, docs)->
      Poll.findById poll._id, (err, poll)->

        for summary in docs
          PollSummary.findOneAndUpdate
            _poll: poll._id
            _user: summary._user
          , $inc:
              score: summary.payout
          ,
            upsert: true
          .exec (err, pollSummary)->
            poll.scores.addToSet pollSummary
            poll.save()

        Competition.findById poll.competition, (err, competition)->
          PollSummary
          .find()
          .where("_poll").in(competition.polls)
          .sort("-score")
          .exec (err, scoresummaries)->
            console.log scoresummaries.length
            for scoresummary in scoresummaries
              CompetitionSummary.findOneAndUpdate
                "_competition": competition._id
                _user: scoresummary._user
              , $inc:
                  score: scoresummary.score
              ,
                upsert: true
              .exec (err, competitionSummary)->
                competition.scores.addToSet competitionSummary
                competition.save()

              UserStats.findOneAndUpdate
                "summary.competition": competition._id
                "_user": scoresummary._user
              ,
                "summary.score": scoresummary.score
                "summary.rank": 1
              ,
                upsert: true
              .exec (err, userSummary)->
                console.log arguments

module.exports = score
