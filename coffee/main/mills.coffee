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
  constructor: ->
    super()
    @board = new MillsBoard
    @turn = millsPlayer.player1

  availableFor: (player) ->
    if @turn == player
      @freeFields()
    else
      []

  freeFields: ->
    arrayWithBooleanIsFree = $.map @board.spots, (spot, i) -> spot.isFree()
    free = []
    for i in [0..arrayWithBooleanIsFree.length - 1]
      free.push(i) if arrayWithBooleanIsFree[i]
    free

  set: (player, fieldNumber) ->
    field = @board.spots[fieldNumber]
    if(field.isFree())
      field.occupiedWith = player
      @changePlayer()
    else
      errorMessage("field occupied")


  errorMessage: (error) -> console.log(error)

  changePlayer: ->
    @turn = if millsPlayer.player1 == @turn then millsPlayer.player2 else millsPlayer.player1

  @stonesAtStart = -> 9
  @fieldsNumber = -> 24