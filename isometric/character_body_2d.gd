extends CharacterBody2D

#Speed of the character
@export var speed: float = 200.0

func _process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("up"):
		input_vector.y -= 1
	if Input.is_action_pressed("down"):
		input_vector.y += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_vector.x += 1

	# Normalize input vector to prevent faster diagonal movement
	input_vector = input_vector.normalized()

	# Adjust for isometric perspective
	var isometric_vector = Vector2(input_vector.x - input_vector.y, (input_vector.x + input_vector.y) / 2)

	# Move the character
	velocity = isometric_vector * speed
	move_and_slide()
