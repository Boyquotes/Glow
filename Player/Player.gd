extends KinematicBody2D

# TODO: More gravity, less floaty.
export(int) var ACCELERATION = 512
export(int) var MAX_SPEED = 64
export(float) var FRICTION = 0.25
export(int) var GRAVITY = 200
export(int) var JUMP_FORCE = 128
export(int) var MAX_SLOPE_ANGLE = 46

onready var coyoteJumpTimer = $CoyoteJumpTimer
onready var sprite = $Sprite
onready var spriteAnimator = $SpriteAnimator
onready var glowLight = $Glow
onready var glowTimer = $GlowTimer
onready var glowCooldownTimer = $GlowCooldownTimer

var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false

func _physics_process(delta):
	just_jumped = false
	var input_vector = get_input_vector()
	
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector, FRICTION)
	update_snap_vector()
	glow_check()
	jump_check()
	apply_gravity(delta)
	update_animations(input_vector)
	move()

func apply_friction(input_vector, friction):
	if input_vector.x == 0 and is_on_floor():
		# lerp: linear interpolation
		motion.x = lerp(motion.x, 0, friction)

func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func apply_horizontal_force(input_vector, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	return input_vector

func jump_check():
	if is_on_floor() or coyoteJumpTimer.time_left > 0:
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMP_FORCE
			just_jumped = true
			snap_vector = Vector2.ZERO
	else:
		if Input.is_action_just_released("jump") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE / 2

func move():
	# This contains hacky code to get move_and_slide_with_snap working properly with slopes,
	# to negate issues with the y-axis movement on slopes
	# James: find a Godot tutorial that covers non-hacky platformer movement :)

	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_position = position
	var last_motion = motion

	motion = move_and_slide_with_snap(motion, snap_vector * 4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))

	# Landing
	if was_in_air and is_on_floor():
		motion.x = last_motion.x
	
	# Just left the ground
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y
		coyoteJumpTimer.start()

func update_animations(input_vector):
	if input_vector.x != 0:
		if sign(input_vector.x) == -1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		spriteAnimator.play("Walk")
	else:
		spriteAnimator.play("Idle")
	
	if not is_on_floor():
		spriteAnimator.play("Jump")

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN

func glow_check():
	print("checking glow")
	if glowTimer.time_left == 0 and glowCooldownTimer.time_left == 0:
		if Input.is_action_just_pressed("glow"):
			glowTimer.start()
			glowCooldownTimer.start()
			print("starting glow")
			print(str(glowCooldownTimer.time_left))
			glowLight.visible = true
	elif glowTimer.time_left > 0:
		print("still glowing")
		print(str(glowCooldownTimer.time_left))
		glowLight.visible = true
	else:
		print("Glow finished!")
		print(str(glowCooldownTimer.time_left))
		glowLight.visible = false
