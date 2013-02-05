mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

userStatsSchema = new Schema
  summary:[
    competition:
      type: ObjectId
      ref: "Competition"
    rank:
      type: Number
    score:
      type: Number

  ]
  _user:
    type: ObjectId
    ref: "User"
  confidenceLevel:
    type: Number

  acheivements: [
    type: ObjectId
    ref: "Achievement"
  ]

module.exports = mongoose.model 'UserStats', userStatsSchema
