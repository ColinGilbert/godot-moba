extends Control

signal scene_change
var clients_list = {}

func _ready():
	Server.add_client()
	$Label.text = "Room ID: " + str(Server.r_id)
	$ItemList.clear()
	$ItemList.add_item("Player ID", null, false)
	$ItemList.add_item("Team", null, false)

func update_clients(c_list):
	$ItemList.clear()
	clients_list = c_list
	$ItemList.add_item("Player ID", null, false)
	$ItemList.add_item("Team", null, false)
	for c in clients_list.keys():
		if c == str(get_tree().get_network_unique_id()):
			$ItemList.add_item(str(c) + " (YOU)", null, false)
			if $ItemList.get_item_count() - 1 == 2:
				$Start.disabled = false
		else:
			$ItemList.add_item(str(c), null, false)
		$ItemList.add_item(str(clients_list[c]["team"]), null, true)

func _on_Start_pressed():
	emit_signal("scene_change", "game_scene")

func _on_Exit_pressed():
	Server.exit_room()
	emit_signal("scene_change", "main_menu")
		
func _on_Timer_timeout():
	Server.update_clients()

func _on_ItemList_item_selected(index):
	if $ItemList.is_item_selectable(index):
		Server.switch_team()
	# $ItemList.unselect_all()
