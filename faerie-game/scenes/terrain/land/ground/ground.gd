extends Node2D

const WIDTH = 128
const HEIGHT = 24
const SPACE = 10
const DECOR_CHANCE = 0.2

const SPRING_FLOWER = preload("res://scenes/terrain/decor/spring_flower/spring_flower.tscn")
const SHRUB = preload("res://scenes/terrain/decor/shrub/shrub.tscn")


func decorate() -> void:
	var decor_options = [
			SPRING_FLOWER,
			SHRUB
	]
	
	var x_pos := 0

	while x_pos < WIDTH:
		x_pos += SPACE

		if randf() < DECOR_CHANCE:
			var decor = decor_options.pick_random().instantiate()

			if decor.WIDTH + x_pos > WIDTH:
				decor.free()
				break

			decor.position = Vector2(x_pos, 0)
			add_child(decor)

			x_pos += decor.WIDTH
