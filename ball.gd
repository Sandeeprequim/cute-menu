extends Node2D

var lane := 0          # 0 = left, 1 = middle, 2 = right
var p := 0.0
var color := Color.WHITE
var consumed := false

func _process(delta):
	p += delta / Perspective.TRAVEL_TIME
	position = Perspective.pos(320.0 + (lane - 1) * 160.0, p)
	scale = Vector2.ONE * Perspective.scale_at(p)
	if p > 1.6:
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 22, color)
	draw_circle(Vector2(-6, -6), 7, Color(1, 1, 1, 0.5))
