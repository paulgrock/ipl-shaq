mongoose = require 'mongoose'
Schema = mongoose.Schema
pollSchema = require '../polls'

competitionSchema = new Schema
  id: String
  status: String
  title: String
  startsAt: Date
  endsAt: Date
  polls: [
    type: ObjectId
    ref: "Poll"
  ]
  stats: [statsSchema]

module.exports = competitionSchema
