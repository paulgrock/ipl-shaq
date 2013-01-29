mongoose = require 'mongoose'
Schema = mongoose.Schema

voteSchema = new Schema
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