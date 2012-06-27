$(document).ready ->
  $("#prev-button, #next-button").addClass("disabled")

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
    $("#prev-button").click (event) ->
      event.preventDefault()
      if !$(this).hasClass("disabled")
        log = game.eventLog
        prevLog = if log.length > 1 then log.slice(0, -1) else []
        $("#prev-button").unbind("click")
        $("#prev-button").addClass("disabled")
        $("#next-button").removeClass("disabled")
        startGame(prevLog)

  initNextButton = (myGame) ->
    $("#next-button").click (event) ->
      event.preventDefault()
      handleEvent = (game, event) ->
        if !$(this).hasClass("disabled")
          positionOfCommands = game.eventLog.length + 1
          prevLog = getGlobalGame().eventLog.slice(0, positionOfCommands)
          $("#next-button").unbind()
          $("#next-button").addClass("disabled")
          startGame(prevLog)
      handleEvent(myGame, event)

  startGame = (rebuildArray = []) ->
    $('body').unbind()
    game = new MillsGame(rebuildArray)
    initLogger(game)
    new MillsUi(game)
    initPrevButton(game)
    initNextButton(game)
    game.start()
    game

  initialData = [{"type":"app","timeStamp":1340782004867,"payload":{"moveTo":"7","type":"set"}},
      {"type":"app","timeStamp":1340782007084,"payload":{"moveTo":"15","type":"set"}},
      {"type":"app","timeStamp":1340782009490,"payload":{"moveTo":"23","type":"set"}},
      {"type":"app","timeStamp":1340782011251,"payload":{"moveTo":"21","type":"set"}},
      {"type":"app","timeStamp":1340782013425,"payload":{"moveTo":"14","type":"set"}},
      {"type":"app","timeStamp":1340782015298,"payload":{"moveTo":"20","type":"set"}}]
  globalGame = startGame(initialData)

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    startGame(rebuildArray)
