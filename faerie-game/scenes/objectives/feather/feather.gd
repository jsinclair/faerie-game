extends Area2D

signal collected

var collectable = true

const DRIFT_SPEED = 10.0
var drift_target = 0.0
var drift_direction = 1
var velocity_y = 0.0

var feathers = [
	"blue",
	"orange",
	"pink",
	"purple",
	"violet",
	"yellow",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = load("res://resources/feathers/" + feathers.pick_random() + "_feather.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_zero_approx(velocity_y):
		drift_target = 10.0
		drift_direction *= -1
		drift_target *= drift_direction
	
	velocity_y = move_toward(velocity_y, drift_target, DRIFT_SPEED * delta)
	drift_target = move_toward(drift_target, 0, DRIFT_SPEED * delta)
	
	position.y += velocity_y * delta


func _on_body_entered(body: Node2D) -> void:
	if collectable and body is Player:
		collectable = false
		collect()

func collect() -> void:
	collected.emit()
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(hide)
	tween.tween_callback(queue_free)
