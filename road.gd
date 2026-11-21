extends Node2D

func _draw():
	var pts := PackedVector2Array([
		Vector2(310, 120), Vector2(330, 120),
		Vector2(640, 360), Vector2(0, 360)])
	draw_colored_polygon(pts, Color("#3b2a5a"))
	draw_line(Vector2(320, 120), Vector2(213, 360), Color("#ffd36b"), 2)
	draw_line(Vector2(320, 120), Vector2(427, 360), Color("#ffd36b"), 2)
