UserStatsModel = require '../mongo/schemas/stats/users'

class UserStats
  constructor: (options = {}) ->

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
