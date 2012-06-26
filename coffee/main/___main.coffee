$(document).ready ->
  millsGame = new MillsGame()

  millsGame.logger (eventArray) -> $("#logger").html(eventArray.join(",<br>"))

  initMillsGui(millsGame)

  millsGame.start()