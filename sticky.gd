extends Node2D

var tex_normal = preload("res://sticky.png")
var tex_blink = preload("res://sticky-blink.png")
var tex_happy = preload("res://sticky-happy.png")
var is_hovering = false

var speed = 0
var direction = Vector2(1, 0)
var screen_size = Vector2()
var window_size = Vector2(96, 96)

var is_dragging = false
var drag_offset = Vector2()

@onready var sprite = $Sprite2D
@onready var area = $Area2D

func _ready():
	var usable_rect = DisplayServer.screen_get_usable_rect()
	var start_x = usable_rect.end.x - window_size.x
	var start_y = usable_rect.end.y - window_size.y
	DisplayServer.window_set_position(Vector2i(start_x, start_y))
	
	screen_size = Vector2(DisplayServer.screen_get_size())
	area.input_event.connect(_on_area_input)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	
	start_blink_loop()

func _physics_process(delta: float) -> void:
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return
	
	var window_position = Vector2(DisplayServer.window_get_position())
	window_position += direction * speed * delta
	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - window_size.y)
	DisplayServer.window_set_position(Vector2i(window_position))
	
	if window_position.x <= 0 or window_position.x >= screen_size.x - window_size.x:
		direction.x *= -1
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

func start_blink_loop():
	while is_inside_tree():
		await get_tree().create_timer(randf_range(3.0, 6.0)).timeout
		if is_hovering: continue
		sprite.texture = tex_blink
		await get_tree().create_timer(0.1).timeout
		sprite.texture = tex_normal

func _on_mouse_entered():
	is_hovering = true
	sprite.texture = tex_happy

func _on_mouse_exited():
	is_hovering = false
	sprite.texture = tex_normal
