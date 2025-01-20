class_name Player
extends CharacterBody2D


const RUN_ACCEL = 30.0
const RUN_SPEED = 500.0

const JUMP_VELOCITY = -300.0
const JUMP_GRAVITY_MODIFIER = 0.3

var was_on_floor := false
var has_double_jumped := false
var is_jump_buffered := false

@onready var jump_timer: Timer = $JumpTimer
@onready var coyote_time: Timer = $CoyoteTime
@onready var jump_buffer: Timer = $JumpBuffer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if was_on_floor:
			coyote_time.start()
		
		if jump_timer.is_stopped():
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * JUMP_GRAVITY_MODIFIER
	else:
		has_double_jumped = false
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		is_jump_buffered = true
		jump_buffer.start()
	elif Input.is_action_just_released("jump"):
		jump_timer.stop()
	
	if is_jump_buffered:
		if is_on_floor() or not coyote_time.is_stopped():
			velocity.y = JUMP_VELOCITY
			jump_timer.start()
			coyote_time.stop()
			is_jump_buffered = false
		elif not has_double_jumped:
			velocity.y = JUMP_VELOCITY
			has_double_jumped = true
			is_jump_buffered = false
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * RUN_SPEED, RUN_ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, RUN_ACCEL)
	
	if not Input.is_action_just_pressed("jump"):
		was_on_floor = is_on_floor()
	else:
		was_on_floor = false
	
	move_and_slide()


func jump() -> void:
	velocity.y = JUMP_VELOCITY
	jump_timer.start()
	coyote_time.stop()


func _on_jump_buffer_timeout() -> void:
	is_jump_buffered = false
