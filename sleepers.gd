extends Node2D

@export var count := 12
var offset := 0.0

func _process(delta):
	offset += delta / Perspective.TRAVEL_TIME
	queue_redraw()

func _draw():
	for i in count:
		var p := fposmod(offset + float(i) / count, 1.0)
		var a := Perspective.pos(80.0, p)
		var b := Perspective.pos(560.0, p)
		draw_line(a, b, Color(0.35, 0.3, 0.25), 1.0 + 3.0 * Perspective.scale_at(p))
