extends Control
signal scene_change


func _on_Exit_pressed():
	emit_signal("scene_change", "main_menu")


func _on_JoinRoom_pressed():
	emit_signal("scene_change", "room_scene")
