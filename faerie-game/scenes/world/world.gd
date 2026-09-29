extends Node2D

@export var ground_scene: PackedScene
@export var shrub_scene: PackedScene
@export var wisp_scene: PackedScene

const SPAWN_TIME = 1
var sum_time = 0

const WORLD_WIDTH = 1152
const WORLD_HEIGHT = 648
const GROUND_HEIGHT = 16
const GROUND_WIDTH = 128

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = CharacterData.selected_character.instantiate()
	player.position = Vector2(328, 288)
	add_child(player)
	
	var level = WORLD_HEIGHT - (GROUND_HEIGHT * 3)
	var max_height_diff = WORLD_HEIGHT * 0.3
	for i in 3:
		generate_floor(level, max_height_diff * 0.3, i)
		level -= max_height_diff
		
		
func generate_floor(at_height: float, max_height_diff: float, skip_segments: int) -> void:
	var current_pos = Vector2(0, at_height)
	var segments = 0
	var skips: Array = []
	while skips.size() < skip_segments:
		var skip_index = randi_range(0, 10)
		if skip_index not in skips:
			skips.append(skip_index)
	
	print(skips)
	while current_pos.x < WORLD_WIDTH:
		var segment_rotation = PI * randf_range(-0.15, 0.15)
	
		# Attempt to stop floor gradients from varying too greatly
		if abs(at_height - (current_pos.y + (GROUND_WIDTH * sin(segment_rotation)))) > max_height_diff:
			segment_rotation *= -1
		
		if segments not in skips:
			var ground = ground_scene.instantiate()
			ground.position = Vector2(current_pos.x, current_pos.y)
			ground.rotation += segment_rotation
			add_child(ground)
			
			# Possibly add a shrub
			if randf() >= 0.4:
				const shrub_base_width = 24
				var y_offset = 0
				if segment_rotation > 0:
					y_offset += shrub_base_width * sin(segment_rotation)
				var x_pos_mod = randf_range(0.15, 0.85)
				var shrub = shrub_scene.instantiate()
				shrub.position = Vector2(
						current_pos.x + ((GROUND_WIDTH * x_pos_mod) * cos(segment_rotation)), 
						current_pos.y + ((GROUND_WIDTH * x_pos_mod) * sin(segment_rotation)) + y_offset)
				add_child(shrub)
		
		current_pos.x += GROUND_WIDTH * cos(segment_rotation)
		current_pos.y += GROUND_WIDTH * sin(segment_rotation)
		segments += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sum_time += delta
	
	while sum_time > SPAWN_TIME:
		sum_time -= SPAWN_TIME
		
		var wisp = wisp_scene.instantiate()
		wisp.use_wisp_color = false
		wisp.custom_color = Color(randf(), randf(), randf())
		wisp.position = Vector2(
			randf_range(0, 1152),
			randf_range(0, 648)
		)
		add_child(wisp)


func _on_hud_leave_game() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/main.tscn")
