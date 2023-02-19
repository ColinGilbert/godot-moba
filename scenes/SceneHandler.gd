extends Node

var loader
var time_max = 100
var current_scene
var wait_frame = 0


func _ready():
	current_scene = load("res://scenes/LoginScene.tscn").instance()
	add_child(current_scene)
	current_scene.connect("scene_change", self, "handle_scene_change")

	
func handle_scene_change(scene_name):
	match scene_name:
		"login_scene":
			loader = ResourceLoader.load_interactive("res://scenes/LoginScene.tscn")
		"room_scene":
			loader = ResourceLoader.load_interactive("res://scenes/RoomScene.tscn")
		"lobby_scene":
			loader = ResourceLoader.load_interactive("res://scenes/Lobby.tscn")
		"main_menu":
			loader = ResourceLoader.load_interactive("res://scenes/MainMenu.tscn")
		"game_scene":
			loader = ResourceLoader.load_interactive("res://scenes/GameScene.tscn")

	if loader == null:
		print("No such scene exists")
		return
		
	$progressbar.value = 0
	$progressbar.visible = true
	set_process(true)
	wait_frame = 1
	current_scene.queue_free()
	
func _process(delta):
	if loader == null:
		set_process(false)
		return
		if wait_frame > 0:
			wait_frame -= 1
			return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var next_scene = loader.get_resource()
			loader = null
			set_new_scene(next_scene)
			break
		elif err == OK:
			update_progress()
		else:
			print(err)
			loader = null
			break
				
func set_new_scene(next_scene):
	$progressbar.visible = false
	current_scene = next_scene.instance()
	current_scene.connect("scene_change", self, "handle_scene_change")
	add_child(current_scene)

func update_progress():
	var progress = (float(loader.get_stage()) / loader.get_stage_count()) * 100
	$progressbar.value = progress
