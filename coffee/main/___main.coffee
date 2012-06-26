$(document).ready ->
  millsGame = new MillsGame()

  millsGame.logger (eventArray) -> $("#logger").html("[" + eventArray.join(",\n") + "]")

  rebuild = false
  initMillsGui(millsGame)

  millsGame.start()

  $("#rebuild-button").click ->
    $('body').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    console.log("#{rebuildArray.length} elements for rebuild")
    millsGame = new MillsGame(rebuildArray)
    rebuild = true
    initMillsGui(millsGame, rebuild)
