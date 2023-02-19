extends Control

signal scene_change
var clients_list = {}

func _ready():
	Server.add_client()
	$Label.text = "Room ID: " + str(Server.r_id)

func _on_Start_pressed():
	emit_signal("scene_change", "game_scene")

func _on_Exit_pressed():
	Server.exit_room()
	emit_signal("scene_change", "main_menu")

func update_clients(c_list):
	$ItemList.clear()
	clients_list = c_list
	$ItemList.add_item("Player ID", null, false)
	$ItemList.add_item("Team", null, false)
	for c in clients_list.keys():
		if c == str(get_tree().get_network_unique_id()):
			$ItemList.add_item(str(c) + " (YOU)", null, false)
		else:
			$ItemList.add_item(str(c), null, false)
		$ItemList.add_item(str(clients_list[c]["team"]), null, false)
		
func _on_Timer_timeout():
	Server.update_clients()
