extends Node2D

var speed = 150
var direction = Vector2(1, 1)
var screen_size = Vector2()
var window_size = Vector2(200, 200)

var is_dragging = false
var drag_offset = Vector2()

@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D

func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	animated_sprite.play("walk")
	area.input_event.connect(_on_area_input)

func _physics_process(delta: float) -> void:
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return
	
	var window_position = Vector2(DisplayServer.window_get_position())
	window_position += direction * speed * delta
	print(window_position)
	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - window_size.y)
	DisplayServer.window_set_position(Vector2i(window_position))
	
	if window_position.x <= 0 or window_position.x >= screen_size.x - window_size.x:
		direction.x *= -1
		animated_sprite.flip_h = !animated_sprite.flip_h
	if window_position.y <= 0 or window_position.y >= screen_size.y - window_size.y:
		direction.y *= -1

func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var win_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else:
			is_dragging = false
