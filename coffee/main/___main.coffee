$(document).ready ->
  startGame = (rebuildArray = []) ->
    millsGame = new MillsGame(rebuildArray)
    millsGame.logger (eventArray) -> $("#logger").attr("value", "[" + eventArray.join(",\n") + "]")
    new MillsUi(millsGame)
    millsGame.start()

  startGame()

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    startGame(rebuildArray)
