extends Node2D

@export var wisp_scene: PackedScene

const SPAWN_TIME = 1
var sum_time = 0

const WORLD_WIDTH = 1152.0
const WORLD_HEIGHT = 648
const FLOOR_HEIGHT = 50
const MIN_GAP_WIDTH = 40
const MAX_GAP_WIDTH = 100

var make_wisp = true

const FEATHER_SCENE = preload("res://scenes/objectives/feather/feather.tscn")
var total_feathers = 0
var feathers_remaining = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = CharacterData.selected_character.instantiate()
	player.position = Vector2(328, 288)
	add_child(player)
	
	var level = WORLD_HEIGHT - FLOOR_HEIGHT
	var max_height_diff = WORLD_HEIGHT * 0.3
	for i in 3:
		generate_floor(level, max_height_diff * 0.2, i)
		level -= max_height_diff


func generate_floor(at_height: float, max_height_diff: float, gaps: int) -> void:
	var current_pos = Vector2(-100, at_height)
	
	var LAND_SCENES = [
			preload("res://scenes/terrain/land/ground/ground.tscn"),
			preload("res://scenes/terrain/land/gravel/gravel.tscn"),
			preload("res://scenes/terrain/land/dirt/dirt.tscn"),
	]
	
	var gap_positions := []
	if gaps > 0:
		var max_gap_range = WORLD_WIDTH / gaps
		for i in gaps:
			gap_positions.append(randf_range(
					i * max_gap_range,
					(i + 1) * max_gap_range))
	
	while current_pos.x < WORLD_WIDTH:
		# Check if its time for a gap
		if gap_positions.size() > 0 and gap_positions[0] <= current_pos.x:
			current_pos.x += randf_range(MIN_GAP_WIDTH, MAX_GAP_WIDTH)
			gap_positions.remove_at(0)
		
		var segment_rotation = PI * randf_range(-0.05, 0.05)
		
		# Instantiate a random land section
		var land = LAND_SCENES.pick_random().instantiate()
	
		# Attempt to stop floor gradients from varying too greatly
		if abs(at_height - (current_pos.y + (land.WIDTH * sin(segment_rotation)))) > max_height_diff:
			segment_rotation *= -1
		
		land.position = Vector2(current_pos.x, current_pos.y)
		land.rotation += segment_rotation
		land.decorate()
		add_child(land)
		
		var x_increase = land.WIDTH * cos(segment_rotation)
		
		if current_pos.x + x_increase >= WORLD_WIDTH:
			var feather_position = current_pos
			feather_position.x -= x_increase / 2
			feather_position.y -= max_height_diff * 2
			spawn_feather(feather_position)
		
		current_pos.x += x_increase
		current_pos.y += land.WIDTH * sin(segment_rotation)


func spawn_feather(feather_position: Vector2) -> void:
	var feather = FEATHER_SCENE.instantiate()

	feather.position = feather_position
	feather.collected.connect(_on_feather_collected)

	add_child(feather)
	feathers_remaining += 1
	total_feathers += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sum_time += delta
	
	while sum_time > SPAWN_TIME:
		sum_time -= SPAWN_TIME
		
		if make_wisp:
			var wisp = wisp_scene.instantiate()
			wisp.custom_color = Color(randf(), randf(), randf())
			wisp.position = Vector2(
				randf_range(0, 1152),
				randf_range(0, 648)
			)
			wisp.hide()
			wisp.modulate.a = 0
			add_child(wisp)
		else:
			var butterfly = preload("res://scenes/critters/butterfly/butterfly.tscn").instantiate()
			butterfly.position = Vector2(
				randf_range(0, 1152),
				randf_range(0, 648)
			)
			add_child(butterfly)
		
		make_wisp = !make_wisp


func _on_hud_leave_game() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/main.tscn")


func _on_feather_collected() -> void:
	feathers_remaining -= 1

	print("%d/%d" % [total_feathers - feathers_remaining, total_feathers])
	if feathers_remaining == 0:
		pass
		#win()
