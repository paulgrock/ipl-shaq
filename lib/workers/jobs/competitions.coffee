Competition = require '../../mongo/schemas/competitions'

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
