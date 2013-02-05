mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

competitionScoreSchema = new Schema
  users:
    type: ObjectId
    ref: "User"
  score:
    type: Number
    required: true

module.exports = mongoose.model 'CompetitionScore', competitionScoreSchema
