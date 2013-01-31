mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

voteSummarySchema = new Schema
  _poll:
    type: ObjectId
    ref: "Poll"
  userId:
    type: Number
    required: true
    unique: true
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


module.exports = voteSummarySchema
