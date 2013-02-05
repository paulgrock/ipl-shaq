mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

pollOptionsSchema = require './pollOptions'

optionsLengthValidator = (value)->
  return value.length is 2

pollSchema = new Schema
  id:
    type: String
    unique: true
  state: String
  title: String
  startsAt:
    type: Date
    default: Date.now()
  endsAt: Date
  pollOptions:
    type: [pollOptionsSchema]
    required: true
    validate: optionsLengthValidator
  total:
    type: Number
    default: 0
  rollingTotal:
    type: Number
    default: 0
  factor:
    type: Number
    default: 2
  stream:
    id: ObjectId
  matchup:
    id: ObjectId
    best_of: Number
    game:
      id: ObjectId
      number: Number
      winner: String
  votes: [
    type: ObjectId
    ref: 'Vote'
  ]
  voteSummary: [
    type: ObjectId
    ref: 'VoteSummary'
  ]
  scores: [
    type: ObjectId
    ref: 'PollSummary'
  ]
  competition:
    type: ObjectId
    ref: "Competitions"

module.exports = pollSchema
