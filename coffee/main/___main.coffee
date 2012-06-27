$(document).ready ->
  startGame = (rebuildArray = []) ->
    $("#prev-button, #next-button").addClass("disabled")
    millsGame = new MillsGame(rebuildArray)
    millsGame.logger (eventArray) ->
      $("#logger").attr("value", "[" + eventArray.join(",\n") + "]")
      $("#prev-button").removeClass("disabled")

    new MillsUi(millsGame)
    millsGame.start()

  startGame()

  $("#rebuild-button").click ->
    $('body, #logger').unbind();
    inputForRebuildAsJson = $("#logger").attr("value")
    rebuildArray = JSON.parse(inputForRebuildAsJson)
    startGame(rebuildArray)
