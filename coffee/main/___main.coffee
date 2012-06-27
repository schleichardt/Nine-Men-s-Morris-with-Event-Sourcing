$(document).ready ->
  millsGame = new MillsGame()

  millsGame.logger (eventArray) -> $("#logger").html("[" + eventArray.join(",\n") + "]")

  rebuild = false
  new MillsUi(millsGame, rebuild)

  millsGame.start()

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    rebuild = true
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)

    millsGame = new MillsGame(rebuildArray)
    millsGame.logger (eventArray) -> $("#logger").attr("value", "[" + eventArray.join(",\n") + "]")
    new MillsUi(millsGame, rebuild)
