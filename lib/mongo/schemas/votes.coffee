mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

voteSchema = new Schema
  _poll:
    type: ObjectId
    ref: "Poll"
  userId:
    type: Number
    required: true
  votedFor:
    type: String
    required: true
  createdAt:
    type: Date
    default: Date.now
    required: true

module.exports = voteSchema
