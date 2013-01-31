mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

userSchema = new Schema
  id:
    type: Number
    unique: true
    required: true
  displayName:
    type: String
    required: true
  thumbnail: String
  name:
    formatted: String
  pushId: String
  twitter: String
  facebook: String
  pollsParticiatedIn: [
    type: ObjectId
    ref: 'Poll'
  ]
  stats: [
    type: ObjectId
    ref: "Stats"
  ]

module.exports = userSchema
