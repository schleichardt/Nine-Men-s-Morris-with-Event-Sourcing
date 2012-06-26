$(document).ready ->
  millsGame = new MillsGame()

  millsGame.logger (eventArray) -> $("#logger").html(eventArray.join(",\n"))

  initMillsGui(millsGame)

  millsGame.start()

