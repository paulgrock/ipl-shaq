EventEmitter = require('events').EventEmitter
PollSummaryModel = require '../mongo/schemas/summaries/polls'

class PollSummary extends EventEmitter
  constructor: (@poll, options = {}) ->
    @on "pollSummary:findOneAndUpdate", @findOneAndUpdate

  findOneAndUpdate: (summary)->
    PollSummaryModel.findOneAndUpdate
      _poll: @poll._id
      _user: summary._user
    , score: summary.payout
    ,
      upsert: true
    .exec (err, pollSummary)=>
      @poll.scores.addToSet pollSummary
      @poll.save()

module.exports = PollSummary
