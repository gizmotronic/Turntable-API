EventEmitter = require('events').EventEmitter

class TestSubject extends EventEmitter
  constructor: (callback) ->
    @callback = callback

  start: ->
    started = Date.now()
    while (Date.now() - started) < 10000
      @emit 'fire'
      if @callback
        @callback()
    @emit 'end'

limit = 10
result = []
accumulator = []

testCallback = ->
  count = 0
  b = new TestSubject ->
    count += 1
  b.on 'end', ->
    console.log "Callback counted to #{count}"
    accumulator.push count
    testEmitter()
  console.log 'starting TestCallback'
  b.start()

testEmitter = ->
  count = 0
  b = new TestSubject()
  b.on 'fire', ->
    count += 1
  .on 'end', ->
    console.log "Emitter counted to #{count}"
    accumulator.push count

    result.push accumulator
    accumulator = []

    limit -= 1
    if limit > 0
      # Next pass
      testCallback()
    else
      # Dump results
      console.log result
  console.log 'starting TestEmitter'
  b.start()

# Start the first test
testCallback()