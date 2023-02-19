extends Control
signal scene_change


func _on_Exit_pressed():
	emit_signal("scene_change", "main_menu")


func _on_JoinRoom_pressed():
	emit_signal("scene_change", "room_scene")


func _on_Timer_timeout():
	Server.update_rooms()

func updated_rooms(rooms_list):
	$ItemList.clear()
	$ItemList.add_item("Room ID", null, false)
	$ItemList.add_item("Players", null, false)
	for r in rooms_list.keys():
		if rooms_list[r]["game_started"] == false:
			$ItemList.add_item(str(r))
			$ItemList.add_item(str(rooms_list[r]["player_count"]), null, false)
