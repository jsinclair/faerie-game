extends CharacterBody2D

const FLIGHT_ACCELERATION = 1400.0
const MAX_FLIGHT_SPEED = -250.0
const ACCELERATION = 1000.0
const DECELERATION = 1200.0
const MAX_SPEED = 350.0
const JUMP_VELOCITY = -150.0

func _ready() -> void:
	#$ColorRect.color = CharacterData.player_color
	pass


func _physics_process(delta: float) -> void:
	# Add flight and gravity.
	if Input.is_action_pressed("move_up"):
		velocity.y = move_toward(velocity.y, MAX_FLIGHT_SPEED, FLIGHT_ACCELERATION * delta)
	elif not is_on_floor():
		velocity += (get_gravity() * 0.3) * delta
		if Input.is_action_pressed("move_down"):
			velocity.y = move_toward(velocity.y, MAX_FLIGHT_SPEED * -1, FLIGHT_ACCELERATION * delta)

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

	move_and_slide()
