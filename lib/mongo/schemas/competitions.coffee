mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

competitionSchema = new Schema
  id:
    type: String
    required: true
  status:
    type: String
    default: "active"
  title: String
  startsAt:
    type: Date
    default: Date.now()
  endsAt:
    type: Date
  polls: [
    type: ObjectId
    ref: "Poll"
  ]

module.exports = competitionSchema
