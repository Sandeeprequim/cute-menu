extends Node2D

func _draw():
	# soft glow: faint circles stacked from big to small
	for i in range(8):
		var r := 130.0 - i * 8.0
		draw_circle(Vector2.ZERO, r, Color(1.0, 0.83, 0.42, 0.06))
	# sun body, slightly see-through
	draw_circle(Vector2.ZERO, 70, Color(1.0, 0.83, 0.42, 0.9))
