EventEmitter = require('events').EventEmitter
CompetitionSummaryModel = require '../mongo/schemas/summaries/competitions'

class CompetitionSummary extends EventEmitter
  constructor: (@competition, options = {}) ->
    @on "competitionSummary:findOneAndUpdate", @findOneAndUpdate

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
