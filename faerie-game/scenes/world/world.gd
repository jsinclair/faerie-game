extends Node2D

@export var ground_scene: PackedScene
@export var gravel_scene: PackedScene
@export var shrub_scene: PackedScene
@export var wisp_scene: PackedScene

const SPAWN_TIME = 1
var sum_time = 0

const WORLD_WIDTH = 1152.0
const WORLD_HEIGHT = 648
const FLOOR_HEIGHT = 50
const MIN_GAP_WIDTH = 40
const MAX_GAP_WIDTH = 100

var make_wisp = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = CharacterData.selected_character.instantiate()
	player.position = Vector2(328, 288)
	add_child(player)
	
	var level = WORLD_HEIGHT - FLOOR_HEIGHT
	var max_height_diff = WORLD_HEIGHT * 0.3
	for i in 3:
		generate_floor(level, max_height_diff * 0.3, i)
		level -= max_height_diff
		
		
func generate_floor(at_height: float, max_height_diff: float, gaps: int) -> void:
	var current_pos = Vector2(-100, at_height)
	
	var LAND_SCENES = [
			ground_scene,
			gravel_scene,
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
		
		var segment_rotation = PI * randf_range(-0.15, 0.15)
		
		# Instantiate a random land section
		var land = LAND_SCENES.pick_random().instantiate()
	
		# Attempt to stop floor gradients from varying too greatly
		if abs(at_height - (current_pos.y + (land.WIDTH * sin(segment_rotation)))) > max_height_diff:
			segment_rotation *= -1
		
		land.position = Vector2(current_pos.x, current_pos.y)
		land.rotation += segment_rotation
		add_child(land)
		
		# Possibly add a shrub
		if randf() >= 0.4:
			const shrub_base_width = 24
			var y_offset = 0
			if segment_rotation > 0:
				y_offset += shrub_base_width * sin(segment_rotation)
			var x_pos_mod = randf_range(0.15, 0.85)
			var shrub = shrub_scene.instantiate()
			shrub.position = Vector2(
					current_pos.x + ((land.WIDTH * x_pos_mod) * cos(segment_rotation)), 
					current_pos.y + ((land.WIDTH * x_pos_mod) * sin(segment_rotation)) + y_offset)
			add_child(shrub)
		
		current_pos.x += land.WIDTH * cos(segment_rotation)
		current_pos.y += land.WIDTH * sin(segment_rotation)


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
			var butterfly = preload("res://scenes/enemies/butterfly/butterfly.tscn").instantiate()
			butterfly.position = Vector2(
				randf_range(0, 1152),
				randf_range(0, 648)
			)
			add_child(butterfly)
		
		make_wisp = !make_wisp


func _on_hud_leave_game() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/main.tscn")
