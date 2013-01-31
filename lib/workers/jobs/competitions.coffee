mongoose = require 'mongoose'
competitionSchema = require '../../mongo/schemas/competitions'
Competition = mongoose.model 'Competition', competitionSchema

competitionJobs =
  new: (competitionData, cb)->
    ###
    Competition.update
      id: userData.id,
      userData,
      upsert: true
      multi: true
    , (err, numberAffected, rawReponse)->
      return cb err if err?
      cb()
    ###

  end: ()->


module.exports = competitionJobs
