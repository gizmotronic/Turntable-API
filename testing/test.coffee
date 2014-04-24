AUTH='NnntQunMHgMWZSGpRmmTPqwK'
ROOMID='5152585a2e381736f7a1e5d7'
USERID='518b245daaa5cd05da14b129'

#AUTH='xxxxxxxxxxxxxxxxxxxxxxxx'
#ROOMID='xxxxxxxxxxxxxxxxxxxxxxxx'
#USERID='xxxxxxxxxxxxxxxxxxxxxxxx'

repl = require('repl')
Bot = require('./src/bot').Bot

bot = new Bot AUTH, USERID
bot.debug = false
disconnected = false

connect = (roomid) ->
  disconnected = false
  console.log 'connect'
  bot.roomRegister ROOMID, (data) ->
    if data?.success
      console.log 'registered successfully'
    else
      console.log 'failed to join room'

bot
  .on 'ready', (data) ->
    console.log 'ready'
    #connect ROOMID
    bot.getUserId 'VeggieBot', (data) ->
      if data.success
        bot.getProfile data.userid, (result) ->
          console.log 'someone else', JSON.stringify result, null, 2
    bot.getProfile USERID, (result) ->
      console.log 'explicit', JSON.stringify result, null, 2
    bot.getProfile (result) ->
      console.log 'implicit', JSON.stringify result, null, 2

  .on 'disconnected', (e) ->
    if not disconnected
      disconnected = true
      console.log "disconnected: #{e}"
      setTimeout connect, 5000, ROOMID

  .on 'error', (err) ->
    console.log "error: #{err}"
    process.exit 1

  .on 'roomChanged', (data) ->
    console.log 'roomChanged ' + data?.room?.name ? 'unknown'

  .on 'speak', (data) ->
      console.log 'speak'
      if /^\/hello$/.test data.text
        bot.speak "Hey! How are you @#{data.name}?"

repl.start('> ').context.bot = bot
