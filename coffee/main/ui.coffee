class MillsUi
  constructor: (@game) ->
    @game.uiEventHandler @handleEvent
    offsets=[0, 95, 185, 280, 370, 460, 550]
    i=0
    for p in @game.board.points()
      $("#mainCanvas").append("<div class='landing-point' id='landing-point-#{i}'></div>")
      landingPointSelector = $("#landing-point-#{i}")
      landingPointSelector.css("margin-left", offsets[p[0]])
      landingPointSelector.css("margin-top", offsets[p[1]])
      i++

    $(".landing-point").droppable
      #active class: draggable is moving and could be dropped here
      #hover class: would be dropped here
      activeClass: "filled"
      hoverClass: "drophover"

  handleEvent: (event) =>
    console.log("MillsUi.handleEvent")
    console.log(event)
    data = event.payload
    if data.phase == "start"
      @enableStartMoves(data.turn, data.fields)

  #todo nach dem setzen wieder deaktivieren
  enableStartMoves: (player, fields) =>
    allowedLandingPoints = $.map(fields, (elementOfArray, indexInArray) -> "#landing-point-#{elementOfArray}")
    $(".morris-stone.player#{player}").draggable
      revert: "invalid"
      snap: allowedLandingPoints.join(",")


initMillsGui = (millsGame) ->
  new MillsUi(millsGame)

nevercalled = ->
  $(".morris-stone").draggable(
    revert: "invalid"
    snap: ".landing-point"
    drag: (event, ui) ->
      x = event.pageX - $("#mainCanvas").offset().left;
      y = event.pageY - $("#mainCanvas").offset().top;
      $("#debug").html(x + " " + y)
  )



