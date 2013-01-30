config = require '../../config'

calculator =
  calculate: (start, total, options)->
    #multiplying by 1000 because ruby uses seconds instead of miliseconds
    since = Math.floor((Date.now() - start * 1000) / 1000 / config.counterInMinutes)
    since = if since >= 9 then 9 else since
    max = (config.maxVoteValue * (100 - 10 * since) / 100)
    for option in options
      val = if total is 0 then 1 else 1 - option.votes / total
      payout = +Math.round(max * val)
      payout = max if isNaN payout
      payout += 10
      option.payout = payout

    return options

module.exports = calculator