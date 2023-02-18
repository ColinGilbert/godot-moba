extends Control

signal scene_change

func _on_Login_pressed():
	emit_signal("scene_change", "game_scene")


func _on_Register_pressed():
	emit_signal("scene_change", "main_menu")
