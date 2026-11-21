extends Node2D

const LANE_COLORS := [Color("#ff4fa3"), Color("#2ee6d6"), Color("#ffd36b")]
var flash := [0.0, 0.0, 0.0]

func _draw():
	for i in 3:
		var c: Color = LANE_COLORS[i]
		var f: float = flash[i]
		var center: Vector2 = Perspective.pos(320.0 + (i - 1) * 160.0, 1.0)
		var r: float = 28.0 + f * 60.0
		draw_arc(center, r, 0.0, TAU, 32, c, 3.0)
		if f > 0.0:
			draw_circle(center, r, Color(c.r, c.g, c.b, 0.3))
