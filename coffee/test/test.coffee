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

