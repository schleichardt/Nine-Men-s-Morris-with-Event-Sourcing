$(document).ready ->
  millsGame = new MillsGame()

  millsGame.logger (eventArray) -> $("#logger").html("[" + eventArray.join(",\n") + "]")

  rebuild = false
  initMillsGui(millsGame)

  millsGame.start()

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    console.log("#{rebuildArray.length} elements for rebuild")
    millsGame = new MillsGame(rebuildArray)

    millsGame.logger (eventArray) -> $("#logger").attr("value", "[" + eventArray.join(",\n") + "]")

    rebuild = true
    initMillsGui(millsGame, rebuild)
