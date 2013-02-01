mongoose = require 'mongoose'
Schema = mongoose.Schema

pollOptionsSchema = new Schema
  name: String
  votes:
    type: Number
    default: 0
  payout:
    type: Number
    min: 0
    max: 500
  rollingVotes:
    type: Number
    default: 0

module.exports = pollOptionsSchema
