mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

competitionSummarySchema = new Schema
  _competition:
    type: ObjectId
    ref: "Competition"
  _user:
    type: ObjectId
    ref: "User"
  score:
    type: Number

module.exports = mongoose.model 'CompetitionSummary', competitionSummarySchema
