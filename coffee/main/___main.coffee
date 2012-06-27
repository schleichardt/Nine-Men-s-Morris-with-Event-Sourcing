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
    $("#next-button").click (event) ->
      event.preventDefault()
      handler = (event) ->
        positionOfCommands = game.eventLog.length + 1
        prevLog = getGlobalGame().eventLog.slice(0, positionOfCommands)
        console.log("local: #{getGlobalGame().eventLog.length} global #{game.eventLog.length}")
#        $("#next-button").addClass("disabled") if getGlobalGame().eventLog.length == game.eventLog.length
        startGame(prevLog)
      handler(event) if !$("#next-button").hasClass("disabled")

  startGame = (rebuildArray = []) ->
    $('body, #next-button, #prev-button').unbind()
    game = new MillsGame(rebuildArray)
    initLogger(game)
    new MillsUi(game)
    game.start()
    initPrevButton(game)
    initNextButton(game)
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
