Poll = require '../mongo/schemas/polls'
PollSummary = require '../mongo/schemas/summaries/polls'
PollSummaryEvent = require '../summaries/polls'

Competition = require '../mongo/schemas/competitions'
CompetitionSummaryEvent = require '../summaries/competitions'

UserStatsEvent = require '../stats/users'
VoteSummary = require '../mongo/schemas/voteSummary'

score =
  calculate: (poll)->
    winner = poll.matchup.game.winner

    VoteSummary.find
       _poll: poll._id
    .where("votedFor").equals(winner)
    .select("_user payout")
    .lean()
    .exec (err, docs)->
      Poll.findById poll._id, (err, poll)->
        pollSummaryEvent = new PollSummaryEvent poll

        for summary in docs
          pollSummaryEvent.emit "pollSummary:findOneAndUpdate", summary

        Competition.findById poll.competition, (err, competition)->
          competitionSummaryEvent = new CompetitionSummaryEvent competition
          userStatsEvent = new UserStatsEvent()

          mapReduceObj =
            map: ->
              emit @_user, @score
            reduce: (key, vals)->
              return Array.sum vals
            query:
              _poll:
                $in: competition.polls

          PollSummary.mapReduce mapReduceObj, (err, scoresummaries, stats)->
            scoresummaries.sort (score1, score2)->
              return score2.value - score1.value

            for scoresummary, index in scoresummaries
              competitionSummaryEvent.emit "competitionSummary:findOneAndUpdate", scoresummary, index + 1
              userStatsEvent.emit "userStats:findOneAndUpdate", competition, scoresummary, index + 1

module.exports = score
