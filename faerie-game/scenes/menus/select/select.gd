extends Control

const PLANT_FAERIE := preload("res://scenes/player/plant_faerie/plant_faerie.tscn")
const ICE_FAERIE := preload("res://scenes/player/ice_faerie/ice_faerie.tscn")


func _on_plant_button_pressed() -> void:
	CharacterData.selected_character = PLANT_FAERIE
	start_game()


func _on_ice_button_pressed() -> void:
	CharacterData.selected_character = ICE_FAERIE
	start_game()


func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
