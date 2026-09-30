extends Node2D

const rotation_speed = PI
const move_target_offset = 60
const speed = 30

var move_target: Vector2
var use_wisp_color = true
var custom_color: Color
var visibility_time = randf_range(2, 4)

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
	
	update_visibility(delta)
	
	
func update_visibility(delta: float) -> void:
	visibility_time -= delta
	
	if visibility_time <= 0:
		visibility_time += randf_range(2, 4)
		var tween := create_tween()
		if visible:
			tween.tween_property(self, "modulate:a", 0.0, 1.0)
			tween.tween_callback(hide)
		else:
			show()
			tween.tween_property(self, "modulate:a", 1.0, 1.0)
		
