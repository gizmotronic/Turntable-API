AUTH='NnntQunMHgMWZSGpRmmTPqwK'
ROOMID='5152585a2e381736f7a1e5d7'
USERID='518b245daaa5cd05da14b129'

#AUTH='xxxxxxxxxxxxxxxxxxxxxxxx'
#ROOMID='xxxxxxxxxxxxxxxxxxxxxxxx'
#USERID='xxxxxxxxxxxxxxxxxxxxxxxx'

Bot = require('./src/bot').Bot
#Bot = require('ttapi')

bot = new Bot AUTH, USERID
bot.debug = false

bot.on 'ready', (data) ->
  console.log 'ready'
  bot.roomRegister ROOMID, (data) ->
    if data?.success
      console.log 'registered successfully'
      bot.getUserId 'VeggieBot', (data) ->
        if data.success
          bot.getProfile data.userid, (result) ->
            console.log JSON.stringify result, null, 2
            bot.getPresence data.userid, (result) ->
              console.log JSON.stringify result, null, 2
              bot.roomDeregister (result) ->
                process.exit 0
      #result = bot.getPresence
      #console.log 'hey!', JSON.stringify result, null, 2
      #bot.getPresence (result) ->
        #console.log 'my presence', JSON.stringify result, null, 2
      #bot.getProfile USERID, (result) ->
        #console.log 'me (explicit)', JSON.stringify result, null, 2
      #bot.getProfile (result) ->
        #console.log 'me (implicit)', JSON.stringify result, null, 2
        #bot.getPresence (result) ->
          #console.log 'my presence', JSON.stringify result, null, 2
    else
      console.log 'failed to join room'
