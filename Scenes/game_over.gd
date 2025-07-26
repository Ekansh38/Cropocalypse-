extends CanvasLayer


func _on_quit_pressed() -> void:
	if OS.has_feature("web"):
		get_tree().change_scene_to_file("res://Scenes/thank_you_screen.tscn")
	else:
		get_tree().quit()
