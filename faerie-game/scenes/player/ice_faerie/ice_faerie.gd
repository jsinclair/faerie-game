extends "res://scenes/player/player.gd"


func _physics_process(delta: float) -> void:
	super(delta)
	
	var move_input := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
	    "move_down"
	)
	
	if not is_on_floor() and move_input != Vector2.ZERO:
		$AnimatedSprite2D.play("flying")
	else:
		$AnimatedSprite2D.play("standing")
