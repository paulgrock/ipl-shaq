mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
competitionSchema = require '../competitions'

competitionStatsSchema = new Schema

module.exports = competitionStatsSchema