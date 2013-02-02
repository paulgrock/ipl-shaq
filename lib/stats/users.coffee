EventEmitter = require('events').EventEmitter
UserStatsModel = require '../mongo/schemas/stats/users'

class UserStats extends EventEmitter
  constructor: (options = {}) ->
    @on "userStats:findOneAndUpdate", @findOneAndUpdate

  findOneAndUpdate: (competition, summary, rank)->
    console.log rank
    UserStatsModel.findOneAndUpdate
      "summary.competition": competition._id
      _user: summary._user
    ,
      "summary.score": summary.score
      "summary.rank": rank
    ,
      upsert: true
    .exec (err, userStats)->

module.exports = UserStats
