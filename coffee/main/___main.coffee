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

    $("#logger").unbind()
#    millsGame.logger (eventArray) -> $("#logger").html("[" + eventArray.join(",\n") + "]")
    millsGame.logger((eventArray) -> $("#logger").attr("value", "[" + eventArray.join(",\n") + "]"); console.log("loggerCALLLED"))

    rebuild = true
    initMillsGui(millsGame, rebuild)
