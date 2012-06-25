stoneWidth=50

offsets=[0, 95, 185, 280, 370, 460, 550]


points=[[0,0],[0,3],[0,6],[3,6],[6,6],[6,3],[6,0],[3,0],[1,1],[1,3],[1,5],[3,5],[5,5],[5,3],[5,1],[3,1],[2,2],[2,3],[2,4],[3,4],[4,4],[4,3],[4,2],[3,2]]


i=0
for p in points
  $("#mainCanvas").append("<div class='landing-point' id='landing-point-#{i}'>lp</div>")
  $("#landing-point-#{i}").css("margin-left", offsets[p[0]])
  $("#landing-point-#{i}").css("margin-top", offsets[p[1]])
  $("#landing-point-#{i}").css("background", "green")
  i++