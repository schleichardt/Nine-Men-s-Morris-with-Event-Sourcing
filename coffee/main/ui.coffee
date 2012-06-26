class MillsUi
  constructor: (@game, rebuild = false) ->
    @initStones()
    @game.uiEventHandler @handleEvent
    @__addLandingPoints()
    @replay() if rebuild

  __addLandingPoints: ->
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
      activeClass: "filled"#active class: draggable is moving and could be dropped here
      hoverClass: "drophover"#hover class: would be dropped here
      drop: (event, ui) ->
        thisAlias.__lockAllStones()
        selectorDraggable = "#" + ui.draggable[0].id
        $(selectorDraggable).removeClass("never-moved")
        id = $(this).attr('id').replace("landing-point-", "")
        thisAlias.getGame().trigger {moveTo: id, type: "set"}

  __lockAllStones: ->
    $(".morris-stone").draggable("option", "disabled", true)

  replay: ->
    @getGame().start()
    log = @getGame().eventLog
    console.log("log size = #{log.length}")
    player = 1
    stone = 1
    for move in log
      data = move.payload
      if data.type == "set"
        element = $("#stone-#{stone}-player#{player}")
        element.prependTo("#landing-point-#{data.moveTo}");
        element.removeClass("never-moved")
        element.draggable( "option", "disabled", true )
        stone++ if player == 2
        player = if player == 1 then 2 else 1
    @getGame().repeatLastUiTrigger()

  handleEvent: (event) =>
    data = event.payload
    console.log("ui:handleEvent: " + JSON.stringify(data))
    if data.phase == "start"
      @enableStartMoves(data.turn, data.fields)

  getGame: -> @game

  enableStartMoves: (player, fields) =>
    @__lockAllStones()
    allowedLandingPoints = $.map(fields, (elementOfArray, indexInArray) -> "#landing-point-#{elementOfArray}")
    element = $(".morris-stone.player#{player}.never-moved")
    element.draggable
      revert: "invalid"
      snap: allowedLandingPoints.join(",")
      #scope: allowedLandingPoints.join(",")

    element.draggable( "option", "disabled", false )#must be called explicit after

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



