mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

pollSummarySchema = new Schema
  _poll:
    type: ObjectId
    ref: "Poll"
  _user:
    type: ObjectId
    ref: "User"
  score:
    type: Number

module.exports = pollSummarySchema
