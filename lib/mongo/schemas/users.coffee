mongoose = require 'mongoose'
Schema = mongoose.Schema

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

module.exports = userSchema