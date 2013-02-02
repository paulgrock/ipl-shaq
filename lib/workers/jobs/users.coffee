User = require '../../mongo/schemas/users'

userJobs =
  new: (userData, cb)->
    User.findOneAndUpdate id: userData.id,
      userData
    ,
      upsert: true
    , (err, numberAffected)->
      return cb err if err?
      cb()

module.exports = userJobs
