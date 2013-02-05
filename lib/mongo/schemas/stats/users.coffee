mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

userStatsSchema = new Schema
  competitions:[
    type: ObjectId
    ref: "CompetitionStats"
  ]
  confidenceLevel:
    type: Number

  acheivements: [
    type: ObjectId
    ref: "achievementsSchema"
  ]

module.exports = userStatsSchema
