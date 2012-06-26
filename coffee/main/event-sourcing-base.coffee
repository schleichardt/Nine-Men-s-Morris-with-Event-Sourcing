
class ApplicationWithEventSourcing
  constructor: (@eventsSuggested = []) ->
    @eventLog = new Array()
    #handle problem this is dynamically scoped with => instead of ->
    $('body').bind 'app', (event) => @eventLog.push(event)

  exportEvents: ->
    result = []
    for eventEntry in @eventLog
      result.push { type: eventEntry.type, timeStamp: eventEntry.timeStamp, payload: eventEntry.payload };
    result


  ###
  adds a logger.
  handler: (eventArray) -> String;
  ###
  logger: (handler) ->
    $('body').bind('app', (event) =>
      logOutput = $.map(@exportEvents(), (elementOfArray, indexInArray) -> JSON.stringify(elementOfArray))
      handler(logOutput)
    )

  replay: ->
    for eventEntry in @eventsSuggested
      $("body").trigger eventEntry;
