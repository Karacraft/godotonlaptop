extends CharacterBody2D

@export_group("Movement Variables")
@export var color_aween : Color = "#fff030"
@export var speed: float = 200.0
@export var run_multiplier = 1.5
@export_subgroup("Movim","Images_")
@export var left_image : Texture2D
@export var right_image : Texture2D
@export var up_image : Texture2D
@export var down_image : Texture2D
#var velocity = Vector2.ZERO

func _init() -> void:
	pass

func _process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	match StateMachine.current_state:
		StateMachine.States.IDLE:
			StateMachine.idle_state()
		StateMachine.States.WALKING:
			StateMachine.walking_state()
		StateMachine.States.RUNNING:
			StateMachine.running_state()

	if Input.is_action_pressed("up"):
		input_vector.y -= 1
		$Sprite2D.texture = up_image
	if Input.is_action_pressed("down"):
		input_vector.y += 1
		$Sprite2D.texture = down_image
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
		$Sprite2D.texture = left_image
	if Input.is_action_pressed("right"):
		input_vector.x += 1
		$Sprite2D.texture = right_image

	# Normalize input vector to prevent faster diagonal movement
	input_vector = input_vector.normalized()

	# Adjust for isometric perspective
	var isometric_vector = Vector2(input_vector.x - input_vector.y, (input_vector.x + input_vector.y) / 2)

	# Move the character
	velocity = isometric_vector * speed
	move_and_slide()
