$(document).ready ->
  $("#prev-button, #next-button").addClass("disabled")

  initLogger = (game) ->
    $("#logger").attr("value", "")
    $("#logger").unbind()
    game.logger (eventArray) ->
      $("#logger").attr("value", "[" + eventArray.join(",\n") + "]")
      $("#prev-button").removeClass("disabled")

  startGame = (rebuildArray = []) ->
    $('body').unbind()
    game = new MillsGame(rebuildArray)
    initLogger(game)
    new MillsUi(game)
    $("#prev-button").click ->
      if !$(this).hasClass("disabled")
        log = game.eventLog
        prevLog = if log.length > 1 then log.slice(0, -1) else []
        console.log("prevlogsize="+prevLog.length)
        $("#prev-button").unbind("click")
        startGame(prevLog)
    game.start()
    game

  globalGame = startGame([])

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    startGame(rebuildArray)
