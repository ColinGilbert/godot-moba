extends KinematicBody

onready var character = $VampireVonDouche
onready var anim_tree = $VampireVonDouche/AnimationTree
onready var state_machine = anim_tree["parameters/playback"]

signal state

var normal_attack_counter = 0
var button_pressed = "none"
var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var timer = 0
var current_tick = 0
const MIN_TIME_BETWEEN_TICKS = 1 / 60.0
const GRAVITY = -0.1

func _on_Controls_direction_vector(dir):
	direction = dir

func state():
	return state_machine.get_current_node()
	
func travel(state):
	state_machine.travel(state)

func animation_time():
	return state_machine.get_current_play_position()

func calc_velocity(dir, speed):
	var vel = Vector3.ZERO
	var dir2d = Vector2(dir.x, dir.z).normalized()
	var collision = move_and_collide(Vector3(dir2d.x * speed, -1, dir2d.y * speed) * MIN_TIME_BETWEEN_TICKS, true, true, true)
	if collision and collision.normal.y > 0.5: # We are on a plane
		if collision.normal.y >= 1:
			vel = Vector3(dir2d.x * speed, 0, dir2d.y * speed)
		elif collision.normal.y > 0.9:
			vel = Vector3(dir2d.x * speed, (1 - collision.normal.y) * 2, dir2d.y * speed)
	else:
		vel = Vector3(dir2d.x * speed, GRAVITY, dir2d.y *speed)
	return vel
	
func _process(delta):
	timer += delta
	while timer >= MIN_TIME_BETWEEN_TICKS:
		timer -= MIN_TIME_BETWEEN_TICKS
		handle_tick()
		current_tick += 1
	emit_signal("state", state())

func handle_tick():
	var client_input = {}
	client_input["D"] = direction
	client_input["R"] = character.rotation.y
	client_input["S"] = state()
	client_input["B"] = button_pressed
	client_input["AT"] = animation_time()
	client_input["C"] = normal_attack_counter
	button_pressed = "none"
	process_input(client_input)

func process_input(input):
	velocity = Vector3.ZERO
	if input["S"] == "dodge":
		normal_attack_counter = 0
		velocity = calc_velocity(character.transform.basis.z, 6)
	#elif input["S"] == "normal_attack":
	#	pass
	elif input["S"] == "special_attack_1":
		normal_attack_counter = 0
	elif input["S"] == "special_attack_2":
		normal_attack_counter = 0
		if input["AT"] < 1.8:
			velocity = calc_velocity(character.transform.basis.z, 6)
		else:
			pass
	elif input["B"] != "none":
		if input["B"] == "normal_attack":
			if input["S"] == "normal_attack_2" or input["C"] > 2:
				travel("normal_attack_3")
				normal_attack_counter = 0				
			elif input["S"] == "normal_attack_1" or input["C"] > 1:
				travel("normal_attack_2")
				normal_attack_counter = 0
			else:
				travel("normal_attack_1")
				normal_attack_counter = 0
		elif input["B"] == "dodge":
			travel("dodge")
		elif input["B"] == "s1_attack":
			travel("special_attack_1")
		elif input["B"] == "s2_attack":
			travel("special_attack_2")
	elif input["S"] == "normal_attack_1":
		if input["AT"] > 0.1:
			velocity = calc_velocity(character.transform.basis.z, 4)
	elif input["S"] == "normal_attack_2":
		velocity = calc_velocity(character.transform.basis.z, 5)
	elif input["S"] == "normal_attack_3":
		velocity = calc_velocity(character.transform.basis.z, 1)
	elif input["S"] == "idle":
		normal_attack_counter = 0
		if input["D"] == Vector3.ZERO:
			velocity = calc_velocity(input["D"], 0)
		else:
			travel("run")
	elif input["S"] == "run":
		normal_attack_counter = 0
		if input["D"] == Vector3.ZERO:
			travel("idle")
		else:
			character.rotation.y = lerp_angle(input["R"], atan2(input["D"].x, input["D"].z), MIN_TIME_BETWEEN_TICKS * 10)
			velocity = calc_velocity(input["D"], MIN_TIME_BETWEEN_TICKS * 20)
	move_and_collide(velocity)


func _on_Controls_dodge():
	button_pressed = "dodge"

func _on_Controls_normal_attack():
	button_pressed = "normal_attack"
	normal_attack_counter += 1

func _on_Controls_s1_attack():
	button_pressed = "s1_attack"

func _on_Controls_s2_attack():
	button_pressed = "s2_attack"
