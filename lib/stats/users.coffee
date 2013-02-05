EventEmitter = require('events').EventEmitter
UserStatsModel = require '../mongo/schemas/stats/users'

class UserStats extends EventEmitter
  constructor: (options = {}) ->
    @on "userStats:findOneAndUpdate", @findOneAndUpdate

  findOneAndUpdate: (competition, summary, rank)->
    UserStatsModel.findOneAndUpdate
      "summary.competition": competition._id
      _user: summary._id
    ,
      "summary.rank": rank
      "summary.score": summary.value
    ,
      upsert: true
    .exec (err, userStats)->

module.exports = UserStats
