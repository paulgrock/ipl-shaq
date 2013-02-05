mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

competitionStatsSchema = new Schema
  rank:
    type: Number
    required: true
  score:
    type: Number
    required: true

module.exports = mongoose.model 'CompetitionStats', competitionStatsSchema
