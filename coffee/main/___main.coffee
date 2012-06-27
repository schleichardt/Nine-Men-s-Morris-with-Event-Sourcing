$(document).ready ->
  $("#prev-button, #next-button").addClass("disabled")

  initLogger = (game) ->
    $("#logger").attr("value", "")
    $("#logger").unbind()
    game.logger (eventArray) ->
      $("#logger").attr("value", "[" + eventArray.join(",\n") + "]")
      $("#prev-button").removeClass("disabled")

  initPrevButton = (game) ->
    $("#prev-button").click ->
      if !$(this).hasClass("disabled")
        log = game.eventLog
        prevLog = if log.length > 1 then log.slice(0, -1) else []
        console.log("prevlogsize="+prevLog.length)
        $("#prev-button").unbind("click")
        $("#next-button").removeClass("disabled")
        startGame(prevLog)

  startGame = (rebuildArray = []) ->
    $('body').unbind()
    game = new MillsGame(rebuildArray)
    initLogger(game)
    new MillsUi(game)
    initPrevButton(game)
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
