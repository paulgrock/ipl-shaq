mongoose = require 'mongoose'
userSchema = require '../../mongo/schemas/users'
User = mongoose.model 'User', userSchema

userJobs =
  new: (userData, cb)->
    User.update
      id: userData.id,
      userData,
      upsert: true
      multi: true
    , (err, numberAffected, rawReponse)->
      return cb err if err?
      cb()

module.exports = userJobs