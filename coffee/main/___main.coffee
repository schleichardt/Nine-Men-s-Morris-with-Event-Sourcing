$(document).ready ->
  millsGame = new ApplicationWithEventSourcing()

  millsGame.logger (eventArray) -> $("#logger").html(eventArray.join("<br>"))

