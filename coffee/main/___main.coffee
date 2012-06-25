$(document).ready ->
  millsGame = new ApplicationWithEventSourcing()

  millsGame.logger (eventArray) -> $("#logger").html(eventArray.join("<br>"))


  $("body").trigger {type:"app", "payload": "foo1"}
  $("body").trigger {type:"app", "payload": "foo3"}