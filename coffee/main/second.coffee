class ApplicationWithEventSourcing
  constructor: (@eventLog = new Array()) ->
    #handle problem this is dynamically scoped with => instead of ->
    $('body').bind('app', (event) => @eventLog.push(event));
