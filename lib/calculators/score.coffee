mongoose = require 'mongoose'
pollSchema = require '../mongo/schemas/polls'
voteSchema = require '../mongo/schemas/votes'
Poll = mongoose.model 'Poll', pollSchema
Vote = mongoose.model 'Vote', voteSchema

score =
  calculate: (poll)->
    winner = "TubbyTheFat" #poll.matchup.game.winner
    mapReduceObject =
      map: ->
        emit this.userId, this.createdAt

      reduce: (key, vals)->
        return vals.sort().reverse()[0]

      out:
        replace: "pollScoreTemp"

    Vote.mapReduce mapReduceObject, (err, model, stats)->
      console.log arguments
      model.find().exec (err, docs)->
        console.log arguments


#     Vote.findOne
#       _poll: poll._id
#     .sort("-createdAt")
#      find the first instance of a user Id
#     .where("")
#     .where("votedFor").equals(winner)
#     .exec (err, docs)=>
#       console.log arguments


    return score

module.exports = score
