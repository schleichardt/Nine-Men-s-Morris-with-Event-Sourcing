test 'ApplicationWithEventSourcingConstruction', ->
  expect 1
  equal new ApplicationWithEventSourcing().eventLog.length, 0, "empty log expected"
  $('body').unbind();

test 'ApplicationWithEventSourcing', ->
  expect 3
  app = new ApplicationWithEventSourcing()
  equal app.eventLog.length, 0, "empty log expected"
  $("body").trigger {"type":"app", "xyz": "foo"}
  equal app.eventLog.length, 1, "one entry in log expected"
  equal app.eventLog[0].xyz, "foo", "property there"
  $('body').unbind();

test 'event serialization', ->
  expect 2
  app = new ApplicationWithEventSourcing()
  $("body").trigger {"type":"app", "payload": "foo1"}
  $("body").trigger {"type":"app", "payload": "foo2"}
  $("body").trigger {"type":"app", "payload": "foo3"}
  exportedEvents = app.exportEvents()
  ok contains(JSON.stringify(exportedEvents), "foo2")

  app = undefined
  restoredApp = new ApplicationWithEventSourcing(exportedEvents)
  restoredApp.replay()
  ok contains(JSON.stringify(restoredApp.exportEvents()), "foo2"), "export again works"
  $('body').unbind();

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
  $("body").trigger {"type":"app", "payload": "foo1"}
  $("body").trigger {"type":"app", "payload": "foo3"}
  equal clojureCounter, 2
  $('body').unbind();

test 'turns at start', ->
  expect 12
  app = new MillsGame()
  logger = []
  app.logger (eventArray) -> logger = eventArray

  app.start()
  ok logger.length >= 1, "after start at least one event should have occured"
  getLast = () -> JSON.parse(logger[logger.length - 1]).payload
  equal getLast().phase, "start", "should show is start phase"
  equal getLast().turn, 1, "player 1 starts"

  app.trigger {moveTo: 2, type: "set"}

  ok logger.length >= 3, "should have informed gui"
  equal getLast().phase, "start", "should contain startphase message"
  equal getLast().turn, 2, "player 2's turn"

  app.trigger {moveTo: 3, type: "set"}

  ok logger.length >= 4, "should have informed gui"
  equal getLast().phase, "start", "should contain startphase message"
  equal getLast().turn, 1, "player 1's turn after second move"

  app.trigger {moveTo: 4, type: "set"}

  ok logger.length >= 6, "should have informed gui"
  equal getLast().phase, "start", "should contain startphase message"
  equal getLast().turn, 2, "player 2's turn after third move"

  $('body').unbind();