mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

voteSchema = new Schema
  _poll:
    type: ObjectId
    ref: "Poll"
  _user:
    type: ObjectId
    ref: "User"
  votedFor:
    type: String
    required: true
  createdAt:
    type: Date
    default: Date.now
    required: true

module.exports = mongoose.model 'Vote', voteSchema
