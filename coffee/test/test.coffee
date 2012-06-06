contains = (haystack, needle) -> haystack.indexOf(needle) != -1

test 'bla',->
  expect(1);
  equal(true, true, "passing test with coffee")


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