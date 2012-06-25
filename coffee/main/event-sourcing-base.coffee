class ApplicationWithEventSourcing
  constructor: (eventsSuggested = []) ->
    @eventLog = new Array()
    #handle problem this is dynamically scoped with => instead of ->
    $('body').bind('app', (event) => @eventLog.push(event));
    for eventEntry in eventsSuggested
      $("body").trigger eventEntry;

  exportEvents: ->
    result =
      for eventEntry in @eventLog
        { type: eventEntry.type, timeStamp: eventEntry.timeStamp, payload: eventEntry.payload };

