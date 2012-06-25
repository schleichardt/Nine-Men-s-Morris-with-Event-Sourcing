$("#marker").append("<strong>CoffeeScript and jQuery works</strong>");

$(".morris-stone").draggable(
  revert: "invalid"
  drag: (event, ui) ->
    x = event.pageX - $("#mainCanvas").offset().left;
    y = event.pageY - $("#mainCanvas").offset().top;
    $("#debug").html(x + " " + y)
)
