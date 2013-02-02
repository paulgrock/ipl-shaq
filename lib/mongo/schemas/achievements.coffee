mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

achievementsSchema = new Schema
  id:
    type: Number
    required: true

module.exports = mongoose.model 'Achievement', achievementsSchema
