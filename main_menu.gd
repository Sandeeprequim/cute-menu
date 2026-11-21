extends Node2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for n in find_children("*", "Button", true, false):
		n.visible = false
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)
	var play := Button.new()
	play.text = "PLAY"
	play.position = Vector2(220, 210)
	play.size = Vector2(200, 44)
	play.pressed.connect(_on_play)
	layer.add_child(play)
	var quit := Button.new()
	quit.text = "EXIT"
	quit.position = Vector2(220, 265)
	quit.size = Vector2(200, 44)
	quit.pressed.connect(_on_exit)
	layer.add_child(quit)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_SPACE):
		_on_play()

func _on_play():
	get_tree().change_scene_to_file("res://track.tscn")

func _on_exit():
	get_tree().quit()
