extends Node2D

const SPEED = 100
const ANGULAR_SPEED = PI

var trajectory_duration = 0
var trajectory_angle_speed = 0
var trajectory_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("flying")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	trajectory_duration -= delta
	
	if trajectory_duration <= 0:
		trajectory_duration = randf_range(1.0, 2.5)
		trajectory_angle_speed = ANGULAR_SPEED * randf_range(0.05, 0.6)
		if randf() < 0.5:
			trajectory_angle_speed = -trajectory_angle_speed
		trajectory_speed = SPEED * randf_range(0.5, 1.2)
	
	rotation += trajectory_angle_speed * delta
	
	var velocity = Vector2.UP.rotated(rotation) * trajectory_speed
	
	position += velocity * delta
