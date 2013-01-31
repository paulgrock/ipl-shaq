mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

competitionSummarySchema = new Schema
  competition:
    type: ObjectId
    ref: "Competition"
  _user:
    type: ObjectId
    ref: "User"
  score:
    type: Number
  rank:
    type: Number

module.exports = competitionSummarySchema
