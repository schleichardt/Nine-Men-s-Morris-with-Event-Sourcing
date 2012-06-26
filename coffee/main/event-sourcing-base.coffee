
class ApplicationWithEventSourcing
  constructor: (@eventsSuggested = []) ->
    @eventLog = new Array()
    #handle problem this is dynamically scoped with => instead of ->
    $('body').bind 'app', (event) =>
      @eventLog.push(event)

  exportEvents: ->
    result = []
    for eventEntry in @eventLog
      result.push @toJson(eventEntry)
    result

  toJson: (event) ->
    { type: event.type, timeStamp: event.timeStamp, payload: event.payload }

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
      console.log("ApplicationWithEventSourcing.replay one entry")
      $("body").trigger eventEntry;