class MillsUi
  constructor: (@game, rebuild = false) ->
    @initStones()
    @game.uiEventHandler @handleEvent
    offsets=[0, 95, 185, 280, 370, 460, 550]
    i=0
    #todo: ggf. wird brett immer falsch herum gezeichnet
    for p in @game.board.points()
      $("#mainCanvas").append("<div class='landing-point' id='landing-point-#{i}'></div>")
      landingPointSelector = $("#landing-point-#{i}")
      landingPointSelector.css("margin-left", offsets[p[0]])
      landingPointSelector.css("margin-top", offsets[p[1]])
      i++
    #todo bug, Steine können übereinander liegen
    thisAlias = this
    $(".landing-point").droppable
      #active class: draggable is moving and could be dropped here
      #hover class: would be dropped here
      activeClass: "filled"
      hoverClass: "drophover"
      drop: (event, ui) ->
        $(".morris-stone").draggable("option", "disabled", true)
        selectorDraggable = "#" + ui.draggable[0].id
        $(selectorDraggable).removeClass("never-moved")
        id = $(this).attr('id').replace("landing-point-", "")
        thisAlias.getGame().trigger {moveTo: id, type: "set"}
    @replay() if rebuild


  replay: ->
    @getGame().replay()
    log = @getGame().eventLog
    player = 1
    stone = 1
    for move in log
      data = move.payload
      if data.type == "set"
        $("#stone-#{stone}-player#{player}").prependTo("#landing-point-#{data.moveTo}");
        stone++ if player == 2
        player = if player == 1 then 2 else 1







  handleEvent: (event) =>
    data = event.payload
    if data.phase == "start"
      @enableStartMoves(data.turn, data.fields)

  getGame: -> @game

  enableStartMoves: (player, fields) =>
    allowedLandingPoints = $.map(fields, (elementOfArray, indexInArray) -> "#landing-point-#{elementOfArray}")
    $(".morris-stone.player#{player}.never-moved").draggable
      revert: "invalid"
      snap: allowedLandingPoints.join(",")
      #scope: allowedLandingPoints.join(",")

    $(".morris-stone.player#{player}").draggable( "option", "disabled", false )#must be called explicit after

  initStones: ->
    $(".morris-stone").remove()
    html = '''<div id="depotPlayer1" class="depot">
                    <h3>Player 1</h3>
                    <div id="stone-1-player1"  class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-2-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-3-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-4-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-5-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-6-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-7-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-8-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                    <div id="stone-9-player1" class="ui-widget-content morris-stone player1 never-moved"></div>
                </div>
                <div id="depotPlayer2" class="depot">
                    <h3>Player 2</h3>
                    <div id="stone-1-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-2-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-3-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-4-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-5-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-6-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-7-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-8-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                    <div id="stone-9-player2" class="ui-widget-content morris-stone player2 never-moved"></div>
                </div>'''
    $("#stoneSource").html(html)


initMillsGui = (millsGame, rebuild = false) ->
  new MillsUi(millsGame, rebuild)

nevercalled = ->
  $(".morris-stone").draggable(
    revert: "invalid"
    snap: ".landing-point"
    drag: (event, ui) ->
      x = event.pageX - $("#mainCanvas").offset().left;
      y = event.pageY - $("#mainCanvas").offset().top;
      $("#debug").html(x + " " + y)
  )



