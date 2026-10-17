extends Node2D

const WIDTH = 32

const MUSHROOM_TEXTURES: Array[Texture2D] = [
	preload("res://resources/decor/mushroom_1.png"),
	preload("res://resources/decor/mushroom_2.png"),
	preload("res://resources/decor/mushroom_3.png"),
	preload("res://resources/decor/mushroom_4.png"),
	preload("res://resources/decor/mushroom_5.png"),
]

func _ready() -> void:
	$Sprite2D.texture = MUSHROOM_TEXTURES.pick_random()
