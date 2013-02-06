CompetitionSummaryModel = require '../mongo/schemas/summaries/competitions'

class CompetitionSummary
  constructor: (@competition, options = {}) ->

  findOneAndUpdate: (summary, rank)->
    CompetitionSummaryModel.findOneAndUpdate
      _competition: @competition._id
      _user: summary._id
    ,
      score: summary.value
      rank: rank
    ,
      upsert: true
    .exec (err, competitionSummary)=>
      @competition.scores.addToSet competitionSummary
      @competition.save()

module.exports = CompetitionSummary
