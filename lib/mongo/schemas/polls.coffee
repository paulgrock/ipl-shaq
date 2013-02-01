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
  competition:
    type: ObjectId
    ref: "Competitions"

pollSchema.pre "save", (next)->
  if @pollOptions[0]?.name? && @pollOptions[1]?.name?
    @title = "#{@pollOptions[0].name} vs #{@pollOptions[1].name}"
  next()

module.exports = pollSchema