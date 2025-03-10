extends Node

# https://www.youtube.com/watch?v=5R0ajAElEgk&ab_channel=Aarimous EDITOR TIPS

# Define possible states
enum States { IDLE, WALKING, RUNNING }
# Current state variable
var current_state = States.IDLE
var cur_state_label = "IDLE"
var new_state_label = ""

# State machine behavior
func _process(delta):
	match current_state:
		States.IDLE:
			idle_state()
		States.WALKING:
			walking_state()
		States.RUNNING:
			running_state()

# State functions
func idle_state():
	print("Character is idle.")
	if Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		change_state(States.WALKING)

func walking_state():
	print("Character is walking.")
	if Input.is_action_just_pressed("shift"):
		change_state(States.RUNNING)
	elif !Input.is_action_pressed("right") and !Input.is_action_pressed("left") or !Input.is_action_pressed("up") or !Input.is_action_pressed("down"):
		change_state(States.IDLE)

func running_state():
	print("Character is running.")
	if !Input.is_action_pressed("shift"):
		change_state(States.WALKING)

# Function to change state
func change_state(new_state):
	match new_state:
		0:
			new_state_label = "IDLE"
		1:
			new_state_label = "WALKING"
		2:
			new_state_label = "RUNNING"

	print("Changing state from %s to %s" % [cur_state_label, new_state_label])
	current_state = new_state
	cur_state_label = new_state_label
