Poll = require '../mongo/schemas/polls'
PollSummary = require '../mongo/schemas/summaries/polls'
PollSummaryEvent = require '../summaries/polls'

Competition = require '../mongo/schemas/competitions'
CompetitionSummaryEvent = require '../summaries/competitions'

UserStatsEvent = require '../stats/users'
VoteSummary = require '../mongo/schemas/voteSummary'

score =
  calculate: (poll)->
    winner = "TubbyTheFat" #poll.matchup.game.winner

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
          PollSummary.find()
          .where("_poll").in(competition.polls)
          .sort("-score")
          .exec (err, scoresummaries)->
            for scoresummary, index in scoresummaries
              competitionSummaryEvent.emit "competitionSummary:findOneAndUpdate", scoresummaries
              userStatsEvent.emit "userStats:findOneAndUpdate", competition, summary, index + 1

module.exports = score
