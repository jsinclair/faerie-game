extends Node2D

const rotation_speed = PI
const move_target_offset = 60
const speed = 50

var move_target: Vector2
var use_wisp_color = true
var custom_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRectBack.color = Color(custom_color, 0.2)
	$ColorRectFore.color = Color(custom_color, 0.3)
	$ColorRectMid.color = Color(custom_color, 0.5)
	
	move_target = Vector2(
		randf_range(position.x - move_target_offset, position.x + move_target_offset),
		randf_range(position.y - move_target_offset, position.y + move_target_offset)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ColorRectMid.rotation += rotation_speed * delta
	$ColorRectFore.rotation -= rotation_speed * delta
	$ColorRectBack.rotation += rotation_speed * delta
	
	if position == move_target:
		move_target = Vector2(
			randf_range(position.x - move_target_offset, position.x + move_target_offset),
			randf_range(position.y - move_target_offset, position.y + move_target_offset)
		)
	else:
		position.x = move_toward(position.x, move_target.x, speed * delta)
		position.y = move_toward(position.y, move_target.y, speed * delta)
