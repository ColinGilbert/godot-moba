extends KinematicBody

onready var character = $VampireVonDouche
onready var anim_tree = $VampireVonDouche/AnimationTree
onready var state_machine = anim_tree["parameters/playback"]

var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var timer = 0
var current_tick = 0
const MIN_TIME_BETWEEN_TICKS = 1 / 60.0

func _on_Controls_direction_vector(dir):
	direction = dir

func state():
	return state_machine.get_current_node()
	
func travel(state):
	state_machine.travel(state)

func _process(delta):
	timer += delta
	while timer >= MIN_TIME_BETWEEN_TICKS:
		timer -= MIN_TIME_BETWEEN_TICKS
		handle_tick()
		current_tick += 1

func handle_tick():
	var client_input = {}
	client_input["D"] = direction
	client_input["R"] = character.rotation.y
	client_input["S"] = state()
	process_input(client_input)

func process_input(input):
	velocity = Vector3.ZERO
	if input["S"] == "idle":
		if input["D"] == Vector3.ZERO:
			pass
		else:
			travel("run")
	elif input["S"] == "run":
		if input["D"] == Vector3.ZERO:
			travel("idle")
		else:
			character.rotation.y = lerp_angle(input["R"], atan2(input["D"].x, input["D"].z), MIN_TIME_BETWEEN_TICKS * 10)
			velocity = 10.0 * input["D"].normalized() * MIN_TIME_BETWEEN_TICKS
	move_and_collide(velocity)
