extends Control
signal scene_change
var selected_room = ""

func enter_room():
	emit_signal("scene_change", "room_scene")
	
func updated_rooms(rooms_list):
	$ItemList.clear()
	$ItemList.add_item("Room ID", null, false)
	$ItemList.add_item("Players", null, false)
	for r in rooms_list.keys():
		if rooms_list[r]["game_started"] == false:
			$ItemList.add_item(str(r))
			if r == selected_room:
				$ItemList.select($ItemList.get_item_count() - 1) # To prevent clearing selection
			$ItemList.add_item(str(rooms_list[r]["player_count"]), null, false)	
	
func _on_Exit_pressed():
	emit_signal("scene_change", "main_menu")

func _on_JoinRoom_pressed():
	var selected = $ItemList.get_selected_items()
	if selected.size() == 1:
		var room_index = selected[0]
		var room_id = $ItemList.get_item_text(room_index)
		Server.request_enter(room_id)
	else:
		print("Error: Nothing selected.")
	#

func _on_Timer_timeout():
	Server.update_rooms()


func _on_ItemList_item_selected(index): # To prevent clearing selection
	selected_room = $ItemList.get_item_text(index)

