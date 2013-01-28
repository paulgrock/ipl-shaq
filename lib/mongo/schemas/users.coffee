mongoose = require 'mongoose'
Schema = mongoose.Schema

userSchema = new Schema
  user:
    id: Number
    displayName: String
    thumbnail: String
    name:
      formatted: String
    pushId: String
    twitter: String
    facebook: String

module.exports = userSchema