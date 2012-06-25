test 'ApplicationWithEventSourcingConstruction', ->
  expect 1
  equal new ApplicationWithEventSourcing().eventLog.length, 0, "empty log expected"

test 'ApplicationWithEventSourcing', ->
  expect 3
  app = new ApplicationWithEventSourcing()
  equal app.eventLog.length, 0, "empty log expected"
  $("body").trigger {type:"app", "xyz": "foo"}
  equal app.eventLog.length, 1, "one entry in log expected"
  equal app.eventLog[0].xyz, "foo", "property there"

test 'event serialization', ->
  expect 2
  app = new ApplicationWithEventSourcing()
  $("body").trigger {type:"app", "payload": "foo1"}
  $("body").trigger {type:"app", "payload": "foo2"}
  $("body").trigger {type:"app", "payload": "foo3"}
  exportedEvents = app.exportEvents()
  ok contains(JSON.stringify(exportedEvents), "foo2")

  app = undefined
  restoredApp = new ApplicationWithEventSourcing(exportedEvents)
  ok contains(JSON.stringify(restoredApp.exportEvents()), "foo2"), "export again works"

test 'json with default values', ->
  expect 3
  json1 =
    one: "value one"
    two: "value two"

  json2 =
    two: "2"
    three: "3"

  merged = mergeJson(json1, json2)
  equal merged.one, "value one"
  equal merged.two, "2", "value merged"
  equal merged.three, "3"

test 'logger', ->
  expect 1
  app = new ApplicationWithEventSourcing()
  clojureCounter = 0
  app.logger (eventArray) -> clojureCounter++
  $("body").trigger {type:"app", "payload": "foo1"}
  $("body").trigger {type:"app", "payload": "foo3"}
  equal clojureCounter, 2

test 'turns at start', ->
  expect 4
  app = new MillsGame()

  equal app.availableFor(millsPlayer.player1).length, MillsGame.fieldsNumber(), "player 1 can start where he likes"
  equal app.availableFor(millsPlayer.player2).length, 0, "player 2 is not allowed to start"
  fieldForPlayer1 = 2 #random value
  app.set(millsPlayer.player1, fieldForPlayer1)
  equal app.availableFor(millsPlayer.player1).length, 0, "it's not player 1 turn"
  equal app.availableFor(millsPlayer.player2).length, MillsGame.fieldsNumber() - 1, "it's player 2's turn and he has only 23 possibilities"
