extends CharacterBody2D
class_name Player

const FLIGHT_ACCELERATION = 1000.0
const MAX_FLIGHT_SPEED = -150.0
const ACCELERATION = 600.0
const DECELERATION = 1200.0
const MAX_SPEED = 250.0
const JUMP_VELOCITY = -150.0

const MAX_ROTATION = PI / 35
var movement_rotation = 0

var hover = false
const DRIFT_SPEED = 10.0
var drift_target = 0
var drift_direction = 1

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	# Add flight and gravity.
	if Input.is_action_pressed("move_up"):
		velocity.y = move_toward(velocity.y, MAX_FLIGHT_SPEED, FLIGHT_ACCELERATION * delta)
	elif not is_on_floor():
		if not hover:
			velocity += (get_gravity() * 0.2) * delta
		if Input.is_action_pressed("move_down"):
			velocity.y = move_toward(velocity.y, MAX_FLIGHT_SPEED * -1, FLIGHT_ACCELERATION * delta)

	# If we are hovering, decay the y movement
	if hover and Input.get_axis("move_up", "move_down") == 0 and drift_target == 0:
		velocity.y = move_toward(velocity.y, 0, ((DECELERATION * 0.2) * delta))
		
		if velocity.y == 0:
			drift_target = 10.0
			drift_direction *= -1
			drift_target *= drift_direction
			pass
	
	if Input.get_axis("move_up", "move_down"):
		drift_target = 0
	
	if drift_target != 0:
		velocity.y = move_toward(velocity.y, drift_target, DRIFT_SPEED * delta)
		drift_target = move_toward(drift_target, 0, DRIFT_SPEED * delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		var accel = ACCELERATION
		if (direction * velocity.x < 0) and is_on_floor():
			accel += DECELERATION
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, (DECELERATION * (1.0 if is_on_floor() else 0.1) * delta))

	# Rotate slightly based on movement
	rotation = MAX_ROTATION * (velocity.x / MAX_SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_hover", false):
		hover = not hover
