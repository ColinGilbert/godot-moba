extends CanvasLayer

onready var camguide_y = get_parent().get_node("Character1/CamGuideY")
onready var camguide_x = get_parent().get_node("Character1/CamGuideY/CamGuideX")
onready var joystick_handle = $Control/JoystickBG/inner

var joystick_center: Vector2
var joystick_vector: Vector2
var joystick_vector_normalized: Vector2
var joystick_index = -1
var attack_index = -1
var s1_index = -1
var s2_index = -1
var dodge_index = -1
var camera_index = -1
var camera_input = Vector2.ZERO
var rotation_velocity_x = 0
var rotation_velocity_y = 0

func _ready():
	joystick_center = joystick_handle.global_position

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if Input.is_action_just_pressed("joystick_action"):
				joystick_index = event.index
			elif Input.is_action_just_pressed("attack_action"):
				attack_index = event.index
			elif Input.is_action_just_pressed("s1_action"):
				s1_index = event.index
			elif Input.is_action_just_pressed("s2_action"):
				s2_index = event.index
			elif Input.is_action_just_pressed("dodge_action"):
				dodge_index = event.index
			else:
				camera_index = event.index
		else:
			if Input.is_action_just_released("joystick_action"):
				joystick_index = -1
				joystick_handle.global_position = joystick_center
			elif Input.is_action_just_released("attack_action"):
				attack_index = -1
			elif Input.is_action_just_released("s1_action"):
				s1_index = -1
			elif Input.is_action_just_released("s2_action"):
				s2_index = -1
			elif Input.is_action_just_released("dodge_action"):
				dodge_index = -1
			else:
				camera_index = -1
	if event is InputEventScreenDrag:
		if event.index == joystick_index:
			joystick_vector = event.position - joystick_center
			joystick_vector_normalized = joystick_vector.normalized()
			joystick_handle.global_position = joystick_center + joystick_vector.clamped(80)
		if event.index == camera_index:
			camera_input = event.relative

func _process(delta):
	$FPSLabel.text = str(Engine.get_frames_per_second()) + " FPS"
	rotation_velocity_x = lerp(rotation_velocity_x, camera_input.x * 0.4, delta*10)
	rotation_velocity_y = lerp(rotation_velocity_y, camera_input.y * 0.15, delta*10)
	camguide_x.rotate_x(deg2rad(-rotation_velocity_y))
	camguide_y.rotate_y(deg2rad(-rotation_velocity_x))
	camguide_x.rotation.x = clamp(camguide_x.rotation.x, -0.5, 0.5)
	camera_input = Vector2.ZERO
