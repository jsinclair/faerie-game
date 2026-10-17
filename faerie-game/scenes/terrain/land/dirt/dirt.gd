extends Node2D

const WIDTH = 192
const HEIGHT = 24
const SPACE = 10
const DECOR_CHANCE = 0.4

const MUSHROOM_SCENE = preload("res://scenes/terrain/decor/mushroom/mushroom.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func decorate() -> void:
	var decor_options = [
			MUSHROOM_SCENE,
	]
	
	var section_width = WIDTH / 3.0
	var x_pos := 0

	while x_pos < WIDTH:
		x_pos += SPACE

		if randf() < DECOR_CHANCE:
			var decor = decor_options.pick_random().instantiate()

			if decor.WIDTH + x_pos > WIDTH:
				decor.free()
				break
				
			# Figure out the y offset based on where we are on the terrain
			var y_offset = 0
			var x_offset = 0
			var angle_ratio = 2.0 / 8.0
			var mid_offset = section_width * angle_ratio
			if x_pos < section_width:
				y_offset = x_pos * angle_ratio
			elif x_pos > 2 * section_width:
				y_offset = mid_offset - ((x_pos - (2 * section_width)) * angle_ratio)
				x_offset = decor.WIDTH
			else:
				y_offset = mid_offset

			decor.position = Vector2(x_pos - x_offset, -y_offset + 3)
			add_child(decor)

			x_pos += decor.WIDTH
