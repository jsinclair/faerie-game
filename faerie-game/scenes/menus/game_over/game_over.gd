extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match GameData.game_result:
		GameData.GameResult.WON:
			$VBoxContainer/MarginContainer/TitleLabel.text = "You Win!"
			$VBoxContainer/MessageLabel.text = "You collected all the feathers, well done!"
		GameData.GameResult.LOST:
			$VBoxContainer/MarginContainer/TitleLabel.text = "Game Over!"
			$VBoxContainer/MessageLabel.text = "Better luck next time!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finish_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/main.tscn")
