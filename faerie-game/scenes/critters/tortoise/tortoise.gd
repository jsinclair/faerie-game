extends CharacterBody2D

enum Activity {
	WALKING,
	RESTING,
}

const SPEED = 50.0
const DECELERATION = 100.0

const EDGE_OFFSET := 24.0
const EDGE_DEPTH := 32.0

# He starts facing to the left
var direction := -1

var wagging_duration = 0.0

var activity := Activity.WALKING
var activity_duration = 0.0
var min_pause_time := 0.5
var max_pause_time := 2.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and not $EdgeDetector.is_colliding():
		direction *= -1
		activity_duration += 0.5
	elif is_on_wall():
		direction *= -1

	match activity:
		Activity.WALKING:
			velocity.x = direction * SPEED
		Activity.RESTING:
			#move_toward(velocity.x, 0.0, DECELERATION * delta)
			velocity.x = 0

	move_and_slide()

	$Visuals.scale.x = -direction
	
	if velocity.x != 0:
		$Visuals/BodySprite.play("walking")
	else:
		$Visuals/BodySprite.play("standing")
	
	handle_wagging(delta)
	update_rotation(delta)
	update_edge_detector()
	update_behaviour(delta)


func handle_wagging(delta: float) -> void:
	wagging_duration -= delta
	if wagging_duration <= 0:
		if randf() > 0.5:
			$Visuals/TailSprite.play()
		else:
			$Visuals/TailSprite.pause()
		wagging_duration += randf_range(3, 6)
	
		
func update_rotation(delta: float) -> void:
	var target_rotation := 0.0

	if is_on_floor():
		target_rotation = get_floor_normal().angle() + PI / 2.0

	$Visuals.rotation = lerp_angle(
		$Visuals.rotation,
		target_rotation,
		minf(1.0, 8.0 * delta)
	)
	

func update_edge_detector() -> void:
	var angle := 0.0

	if is_on_floor():
		angle = get_floor_normal().angle() + PI / 2.0

	var offset_x := direction * EDGE_OFFSET
	var offset_y := tan(angle) * (offset_x)

	$EdgeDetector.position = Vector2(offset_x, offset_y - 10)
	$EdgeDetector.rotation = 0.0


func update_behaviour(delta: float) -> void:
	activity_duration -= delta
	if activity_duration <= 0:
		activity_duration += randf_range(min_pause_time, max_pause_time)
		activity = Activity.WALKING if randf() < 0.6 else Activity.RESTING
		direction = direction if randf() < 0.3 else -direction
