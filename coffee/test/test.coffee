test 'ApplicationWithEventSourcingConstruction', ->
  expect 1
  equal new ApplicationWithEventSourcing().eventLog.length, 0, "empty log expected"
  $('body').unbind();

test 'ApplicationWithEventSourcing', ->
  expect 3
  $('body').unbind();
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
  $('body').unbind();
  expect 14
  app = new MillsGame()
  commandLogger = []
  uiLogger = []
  app.logger (eventArray) -> commandLogger = eventArray
  app.uiEventHandler (event) -> uiLogger.push(event)

  app.start()

  equal commandLogger.length, 0, "no commands sent"
  equal uiLogger.length, 1, "start signal should have sent"

  lastUiLog = () -> uiLogger[uiLogger.length - 1].payload
  equal lastUiLog().phase, "start", "should show is start phase"
  equal lastUiLog().turn, 1, "player 1 starts"

  app.trigger {moveTo: 2, type: "set"}

  equal commandLogger.length, 1, "1 stone set, 1 command"
  equal lastUiLog().phase, "start", "should contain startphase message"
  equal lastUiLog().turn, 2, "player 2's turn"

  app.trigger {moveTo: 3, type: "set"}

  equal commandLogger.length, 2, "2 stones set => 2 commands"
  equal lastUiLog().phase, "start", "should contain startphase message"
  equal lastUiLog().turn, 1, "player 1's turn after second move"

  app.trigger {moveTo: 4, type: "set"}

  equal uiLogger.length, 4, "should have informed gui"
  equal commandLogger.length, 3, "3 stones - 3 commands"
  equal lastUiLog().phase, "start", "should contain startphase message"
  equal lastUiLog().turn, 2, "player 2's turn after third move"

  $('body').unbind();

test 'full replay mills', ->
  expect 0
  initialData = [{"type":"app","timeStamp":1340710665514,"payload":{"moveTo":"7","type":"set"}},
    {"type":"app","timeStamp":1340710666643,"payload":{"moveTo":"14","type":"set"}},
    {"type":"app","timeStamp":1340710667761,"payload":{"moveTo":"6","type":"set"}},
    {"type":"app","timeStamp":1340710669138,"payload":{"moveTo":"13","type":"set"}},
    {"type":"app","timeStamp":1340710671763,"payload":{"moveTo":"15","type":"set"}},
    {"type":"app","timeStamp":1340710673986,"payload":{"moveTo":"12","type":"set"}},
    {"type":"app","timeStamp":1340710675411,"payload":{"moveTo":"22","type":"set"}},
    {"type":"app","timeStamp":1340710676668,"payload":{"moveTo":"21","type":"set"}},
    {"type":"app","timeStamp":1340710677971,"payload":{"moveTo":"20","type":"set"}},
    {"type":"app","timeStamp":1340710679107,"payload":{"moveTo":"23","type":"set"}},
    {"type":"app","timeStamp":1340710682963,"payload":{"moveTo":"16","type":"set"}},
    {"type":"app","timeStamp":1340710686792,"payload":{"moveTo":"11","type":"set"}},
    {"type":"app","timeStamp":1340710688163,"payload":{"moveTo":"19","type":"set"}},
    {"type":"app","timeStamp":1340710689593,"payload":{"moveTo":"3","type":"set"}},
    {"type":"app","timeStamp":1340710691568,"payload":{"moveTo":"0","type":"set"}},
    {"type":"app","timeStamp":1340710694881,"payload":{"moveTo":"5","type":"set"}},
    {"type":"app","timeStamp":1340710696256,"payload":{"moveTo":"1","type":"set"}},
    {"type":"app","timeStamp":1340710697689,"payload":{"moveTo":"10","type":"set"}}]

  app = new MillsGame(initialData)
  app.replay()
