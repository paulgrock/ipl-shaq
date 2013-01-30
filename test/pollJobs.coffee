chai = require 'chai'
pollJobs = require '../lib/mongo/jobs/polls'
expect = chai.expect
chai.should()
pollData =
    id: "5005fd51de8cd169b1000079"
    state: "active"
    start: "1358882408"
    end: "null"
    factor: "2"
    matchup:
        id: "505907b9b7d4e05e62000089"
        best_of: "9"
        game:
            id: "505907b9b7d4e05e62938558"
            number: "1"
            winner: ""
    options: [
      name: "DongRaeGu"
    ,
      name: "TubbyTheFat"
    ]
    stream:
        id: "5088c239f767afac6e000001"

describe "Poll Jobs", ->
  beforeEach ->

  it "Should take poll data", ->

    pollJobs.create pollData, done()