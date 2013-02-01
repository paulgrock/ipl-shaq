mongoose = require 'mongoose'
userSchema = require '../../mongo/schemas/users'
User = mongoose.model 'User', userSchema

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
