extends CharacterBody2D

# States for State Machine
enum States{ AIR = 1, FLOOR, WALL}
# Player in space (check main its floating)
var state = States.AIR
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var SPEED = 210
@export var JUMP_FORCE = -480
@export var WALL_JUMP_FORCE = 480
@export var WALL_SLIDE_GRAVITY = 480
var direction = 1 # 1 right, 0 none, -1 left

func _physics_process(delta):
#	Set Direciton
	set_direction()
#	print(state)
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
			elif is_near_wall():
				state = States.WALL
			else:
				user_input()
				move_and_fall(delta,false)
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			else:
				user_input()
				handle_jump()
				move_and_fall(delta,false)
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
			elif not is_near_wall():
				state = States.AIR
			else:
				$AnimatedSprite2D.play("wall")
			# Add Wall Jump
			if Input.is_action_pressed("jump") and ((Input.is_action_pressed("left") and direction == 1 ) or ( Input.is_action_pressed("right") and direction == -1)):
				velocity.x = 200 * -direction
				velocity.y = 480
				state = States.AIR
			move_and_fall(delta,true)

func move_and_fall(delta,slow_fall : bool):
	velocity.y += gravity * delta
	if state == States.AIR:
		$AnimatedSprite2D.play("fall")
	if slow_fall:
		velocity.y = clamp(velocity.y * delta,10,WALL_SLIDE_GRAVITY)
	move_and_slide()

func handle_jump():
	if Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("fall")
		velocity.y = JUMP_FORCE
		state = States.AIR

func user_input():
	direction = Input.get_axis("left","right")

	velocity.x = SPEED * direction
	if direction == -1:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
	pass

func is_near_wall():
	return $WallChecker.is_colliding()

func set_direction():
	direction = 1 if not $AnimatedSprite2D.flip_h else -1
	$WallChecker.rotation_degrees = 90 * -direction
	pass
