mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

pollOptionsSchema = require './pollOptions'
voteSchema = require './votes'

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
  votes: [voteSchema]
  competition:
    id: ObjectId

pollSchema.pre "init", (next)->
  console.log "init"
  next()

module.exports = pollSchema