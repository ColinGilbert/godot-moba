extends Control

signal scene_change

func _on_CreateRoom_pressed():
	Server.create_room()
	#emit_signal("scene_change", "room_scene")

func _on_JoinRoom_pressed():
	emit_signal("scene_change", "lobby_scene")

func enter_room():
	emit_signal("scene_change", "room_scene")
