$(document).ready ->
  #stores game if time query temporary hides the real game
  globalGame = undefined
  getGlobalGame = -> globalGame


  initLogger = (game) ->
    $("#logger").attr("value", "")
    $("#logger").unbind()
    game.logger (eventArray) ->
      $("#logger").attr("value", "[" + eventArray.join(",\n") + "]")
      $("#prev-button").removeClass("disabled")

  initPrevButton = (game) ->
    if game.eventLog.length < 1
      $("#prev-button").addClass("disabled")
    $("#prev-button").click (event) ->
      event.preventDefault()
      if !$("#prev-button").hasClass("disabled")
        log = game.eventLog
        prevLog = if log.length > 1 then log.slice(0, -1) else []
        startGame(prevLog)
        $("#next-button").removeClass("disabled")


  initNextButton = (game) ->
    console.log("initNextButton")
    $("body").bind "stoneMovedByUser", -> $("#next-button").addClass("disabled")
    $("#next-button").click (event) ->
      event.preventDefault()
      handler = (event) ->
        positionOfCommands = game.eventLog.length + 1
        prevLog = getGlobalGame().eventLog.slice(0, positionOfCommands)
        console.log("local: #{getGlobalGame().eventLog.length} global #{game.eventLog.length}")
        startGame(prevLog)
      handler(event) if !$("#next-button").hasClass("disabled")

  startGame = (rebuildArray = []) ->
    $('body, #next-button, #prev-button').unbind()
    game = new MillsGame(rebuildArray)
    initLogger(game)
    new MillsUi(game)
    game.start()
    $("#next-button").addClass("disabled") if getGlobalGame() && getGlobalGame().eventLog.length == game.eventLog.length
    initPrevButton(game)
    initNextButton(game)
    $("body").bind "stoneMovedByUser", -> globalGame = game
    game

  globalGame = startGame()

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    startGame(rebuildArray)
