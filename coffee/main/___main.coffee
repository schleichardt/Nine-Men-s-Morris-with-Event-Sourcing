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
    console.log("gameSize start #{game.eventLog.length}")
    $("body").bind "stoneMovedByUser", -> $("#next-button").addClass("disabled")
    $("#next-button").click (event) ->
      console.log("gameSize click #{game.eventLog.length}")
      getGame = -> game
      event.preventDefault()
      if !$("#next-button").hasClass("disabled")
        console.log("gameSize handler #{game.eventLog.length}")
        positionOfCommands = getGame().eventLog.length + 1
        prevLog = getGlobalGame().eventLog.slice(0, positionOfCommands)
        console.log("global: #{getGlobalGame().eventLog.length} local #{getGame().eventLog.length} positionOfCommands=#{positionOfCommands} prevlogsize=#{prevLog.length}")
        startGame(prevLog)

  startGame = (rebuildArray = []) ->
    $('body, #next-button, #prev-button').unbind()
    game = new MillsGame(rebuildArray)
    globalGame = game if globalGame == undefined
    initLogger(game)
    new MillsUi(game)
    game.start()
    $("#next-button").addClass("disabled") if getGlobalGame() && getGlobalGame().eventLog.length == game.eventLog.length
    initPrevButton(game)
    console.log("global: #{getGlobalGame().eventLog.length} ") if getGlobalGame()
    initNextButton(game)
    $("body").bind "stoneMovedByUser", -> globalGame = game; console.log("stone moved by user")
    game

  startGame()

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    globalGame = startGame(rebuildArray)
