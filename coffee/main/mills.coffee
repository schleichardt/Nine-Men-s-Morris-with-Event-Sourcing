millsPlayer =
  player1: 1
  player2: 2
  none: 3

class MillsBoardSpot
  constructor: (@id, @neighbours...)->
    @occupiedWith = millsPlayer.none

  isFree: -> @occupiedWith == millsPlayer.none


class MillsBoard
  constructor: ->
    @spots = []
    # outer circle
    @spots.push(new MillsBoardSpot(1, 2, 8))
    @spots.push(new MillsBoardSpot(2, 1, 3, 10))
    @spots.push(new MillsBoardSpot(3, 2, 4))
    @spots.push(new MillsBoardSpot(4, 3, 5, 12))
    @spots.push(new MillsBoardSpot(5, 4, 6))
    @spots.push(new MillsBoardSpot(6, 5, 7, 14))
    @spots.push(new MillsBoardSpot(7, 6, 8))
    @spots.push(new MillsBoardSpot(8, 7, 1, 16))
    @spots.push(new MillsBoardSpot(9, 10, 16))
    # middle circle
    @spots.push(new MillsBoardSpot(10, 9, 11, 2, 18))
    @spots.push(new MillsBoardSpot(11, 10, 12))
    @spots.push(new MillsBoardSpot(12, 11, 4, 20, 13))
    @spots.push(new MillsBoardSpot(13, 12, 14))
    @spots.push(new MillsBoardSpot(14, 13, 22, 6, 15))
    @spots.push(new MillsBoardSpot(15, 14, 16))
    @spots.push(new MillsBoardSpot(16, 15, 24, 8, 9))
    # inner circle
    @spots.push(new MillsBoardSpot(17, 18, 24))
    @spots.push(new MillsBoardSpot(18, 17, 19, 10))
    @spots.push(new MillsBoardSpot(19, 18, 20))
    @spots.push(new MillsBoardSpot(20, 19, 12, 21))
    @spots.push(new MillsBoardSpot(21, 20, 22))
    @spots.push(new MillsBoardSpot(22, 21, 23, 14))
    @spots.push(new MillsBoardSpot(23, 22, 24))
    @spots.push(new MillsBoardSpot(24, 23, 16, 17))


  toDebugString: ->
    JSON.stringify(this)

  ### which points of the raster can contain a stone ###
  points: -> [[0,0],[0,3],[0,6],[3,6],[6,6],[6,3],[6,0],[3,0],[1,1],[1,3],[1,5],[3,5],[5,5],[5,3],[5,1],[3,1],[2,2],[2,3],[2,4],[3,4],[4,4],[4,3],[4,2],[3,2]]



class MillsGame extends ApplicationWithEventSourcing
  constructor: (eventsSuggested = []) ->
    super(eventsSuggested)
    @board = new MillsBoard
    @moveNumber = 0

  start: ->
    $('body').bind 'app', (event) => @eventOccured(event)
    if @eventsSuggested.length == 0
      @triggerUi {"turn": millsPlayer.player1, "phase": "start", "fields": @freeFields()}
    else
      @replay()
      @triggerUi {"phase": "replay"}

  turn: ->
    if @eventLog.length == 0
      millsPlayer.player1
    else
      @moveId() % 2 + 1

  moveId: ->
    result = @eventLog.filter (event) -> event.payload.type == "set"
    result.length

  # returns the last entry of the log
  lastEntry: ->
    @payloadForLogElement(@eventLog.length - 1)

  trigger: (jsonDataEvent) ->
    realData = new Object()
    realData.type = "app"
    realData.payload = jsonDataEvent
    $("body").trigger realData

  triggerUi: (jsonDataEvent) ->
    realData = new Object()
    realData.type = "ui"
    realData.payload = jsonDataEvent
    @lastUiTriggerData = realData if jsonDataEvent.phase != "replay"
    $("body").trigger realData
    #alert("ui triggered " + jsonDataEvent)

  repeatLastUiTrigger: ->
    $("body").trigger @lastUiTriggerData

  @fieldsNumber: -> 24
  @stonesAtStart: -> 9

  freeFields: ->
    arrayWithBooleanIsFree = $.map @board.spots, (spot, i) -> spot.isFree()
    free = []
    for i in [0..arrayWithBooleanIsFree.length - 1]
      free.push(i) if arrayWithBooleanIsFree[i]
    free

  phase: ->
    if @moveNumber <= MillsGame.stonesAtStart() * 2 then "start" else "normal"


  eventOccured: (event) ->
    data = event.payload
    if data.type == "set"
      field = @board.spots[data.moveTo]
      if(field.isFree())
        field.occupiedWith = @turn()
        if @moveNumber < MillsGame.stonesAtStart() * 2
          @triggerUi {"turn": @turn(), "phase": "start", "fields": @freeFields()}
        else
           alert("not anymore at start phase, not implemented")
    else
      console.log(@toJson(event))

  payloadForLogElement: (index) ->
    @toJson(@eventLog[index]).payload

  errorMessage: (error) -> console.log(error)

  otherPlayer: (player) -> if player == millsPlayer.player1 then millsPlayer.player2 else millsPlayer.player1

  uiEventHandler: (handler) ->
    $('body').bind 'ui', (event) -> handler(event)
