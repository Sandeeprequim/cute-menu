extends Node2D

const BallScript = preload("res://ball.gd")
const PadsScript = preload("res://pads.gd")
const BPM := 120.0
const SPAWN_EVERY_BEATS := 2
const PERFECT := 0.08   # seconds
const GOOD := 0.18      # seconds
const LANE_COLORS := [Color("#ff4fa3"), Color("#2ee6d6"), Color("#ffd36b")]
const MELODY := [1.0, 1.122, 1.26, 1.5, 1.68, 1.5, 1.26, 1.122]

var balls
var label
@onready var music = get_node_or_null("Music")
var note_player := AudioStreamPlayer.new()
var flash := [0.0, 0.0, 0.0]
var score := 0
var lives := 5
var combo := 0
var note_index := 0
var clock := 0.0
var next_beat := 0
var music_started := false
var missed_recently := false
var message := ""
var message_t := 0.0

func _ready():
	balls = Node2D.new()
	balls.set_script(PadsScript)
	add_child(balls)
	balls.flash = flash
	var ui := CanvasLayer.new()
	add_child(ui)
	label = Label.new()
	label.position = Vector2(10, 10)
	ui.add_child(label)
	note_player.stream = _make_beep()
	add_child(note_player)
	_update_label()

func _make_beep() -> AudioStreamWAV:
	var rate := 22050
	var n := int(rate * 0.25)
	var data := PackedByteArray()
	data.resize(n * 2)
	for i in n:
		var t := float(i) / rate
		var env := 1.0 - float(i) / n
		data.encode_s16(i * 2, int(sin(TAU * 440.0 * t) * env * 12000.0))
	var s := AudioStreamWAV.new()
	s.format = AudioStreamWAV.FORMAT_16_BITS
	s.mix_rate = rate
	s.data = data
	return s

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_A, KEY_LEFT:
				_try_consume(0)
			KEY_S, KEY_DOWN:
				_try_consume(1)
			KEY_D, KEY_RIGHT:
				_try_consume(2)

func _try_consume(lane: int):
	flash[lane] = 0.15
	var best = null
	var best_dt := 999.0
	for b in balls.get_children():
		if b.lane != lane or b.consumed:
			continue
		var dt: float = (1.0 - b.p) * Perspective.TRAVEL_TIME
		if abs(dt) < abs(best_dt):
			best = b
			best_dt = dt
	if best == null or abs(best_dt) > GOOD:
		return
	best.consumed = true
	best.queue_free()
	_on_hit(abs(best_dt) <= PERFECT)

func _process(delta):
	clock += delta
	var beat_len := 60.0 / BPM
	while clock >= next_beat * beat_len:
		if next_beat % SPAWN_EVERY_BEATS == 0:
			_spawn(clock - next_beat * beat_len)
		next_beat += 1
	if music != null and not music_started and clock >= Perspective.TRAVEL_TIME:
		music_started = true
		music.play()
	for b in balls.get_children():
		if not b.consumed and (b.p - 1.0) * Perspective.TRAVEL_TIME > GOOD:
			b.consumed = true
			b.queue_free()
			_on_miss()
	for i in 3:
		flash[i] = max(flash[i] - delta, 0.0)
	if message_t > 0.0:
		message_t -= delta
		if message_t <= 0.0:
			message = ""
			_update_label()
	balls.queue_redraw()

func _spawn(late: float):
	var b = BallScript.new()
	b.lane = randi_range(0, 2)
	b.color = LANE_COLORS[b.lane]
	b.p = late / Perspective.TRAVEL_TIME
	balls.add_child(b)

func _on_hit(perfect: bool):
	combo += 1
	score += (2 if perfect else 1) * (1 + combo / 10)
	note_player.pitch_scale = MELODY[note_index % MELODY.size()]
	note_index += 1
	note_player.play()
	message = "PERFECT" if perfect else "GOOD"
	if missed_recently and combo >= 3:
		missed_recently = false
		message = "BOUNCE BACK!"
	message_t = 0.7
	_update_label()

func _on_miss():
	lives -= 1
	combo = 0
	missed_recently = true
	note_index = 0
	note_player.pitch_scale = 0.5
	note_player.play()
	message = "MISS"
	message_t = 0.7
	_update_label()
	if lives <= 0:
		if ResourceLoader.exists("res://main_menu.tscn"):
			get_tree().change_scene_to_file("res://main_menu.tscn")
		else:
			get_tree().reload_current_scene()

func _update_label():
	var extra := message if message != "" else "Keys: A S D"
	label.text = "Score %d   Combo %d   Lives %d   %s" % [score, combo, lives, extra]
