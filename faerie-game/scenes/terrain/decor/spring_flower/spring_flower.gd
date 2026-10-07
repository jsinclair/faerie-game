extends Node2D

const WIDTH = 32

const FLOWER_TEXTURES: Array[Texture2D] = [
	preload("res://resources/decor/spring_flower_1.png"),
	preload("res://resources/decor/spring_flower_2.png"),
	preload("res://resources/decor/spring_flower_3.png"),
]

func _ready() -> void:
	$Sprite2D.texture = FLOWER_TEXTURES.pick_random()
