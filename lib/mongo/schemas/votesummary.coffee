mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

voteSummarySchema = new Schema
  _poll:
    type: ObjectId
    ref: "Poll"
  _user:
    type: ObjectId
    ref: "User"
  votedFor:
    type: String
    required: true
  payout:
    type: Number
    default: 0
    required: true
  count:
    type: Number
    default: 0
    required: true


module.exports = mongoose.model 'VoteSummary', voteSummarySchema
