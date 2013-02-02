EventEmitter = require('events').EventEmitter
CompetitionSummaryModel = require '../mongo/schemas/summaries/competitions'

class CompetitionSummary extends EventEmitter
  constructor: (@competition, options = {}) ->
    @on "competitionSummary:findOneAndUpdate", @findOneAndUpdate

  findOneAndUpdate: (summary)->
    CompetitionSummaryModel.findOneAndUpdate
      _competition: @competition._id
      _user: summary._user
    , $inc:
        score: summary.score
    ,
      upsert: true
    .exec (err, competitionSummary)=>
      @competition.scores.addToSet competitionSummary
      @competition.save()

module.exports = CompetitionSummary
