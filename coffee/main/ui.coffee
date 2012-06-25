$(".morris-stone").draggable(
  revert: "invalid"
  snap: ".landing-point"
  drag: (event, ui) ->
    x = event.pageX - $("#mainCanvas").offset().left;
    y = event.pageY - $("#mainCanvas").offset().top;
    $("#debug").html(x + " " + y)
)


stoneWidth=50

offsets=[0, 95, 185, 280, 370, 460, 550]


points=[[0,0],[0,3],[0,6],[3,6],[6,6],[6,3],[6,0],[3,0],[1,1],[1,3],[1,5],[3,5],[5,5],[5,3],[5,1],[3,1],[2,2],[2,3],[2,4],[3,4],[4,4],[4,3],[4,2],[3,2]]


i=0
for p in points
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