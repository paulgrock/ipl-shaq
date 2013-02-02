EventEmitter = require 'events'

PollSummary = require '../mongo/schemas/summaries/polls'

class PollSummary extends EventEmitter
  constructor: (options = {}) ->
    @on "pollsummary:findOneAndUpdate", (poll, user, payout)->


module.exports = PollSummary
