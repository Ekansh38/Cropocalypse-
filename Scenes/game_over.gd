extends CanvasLayer


func _on_quit_pressed() -> void:
	$ClickSFX.play()
	await $ClickSFX.finished
	print("PRESSSSSSSEDDD!!!!")
	if OS.has_feature("web"):
		get_tree().change_scene_to_file("res://Scenes/thank_you_screen.tscn")
	else:
		get_tree().quit()


func _on_replay_pressed() -> void:
	$ClickSFX.play()
	await $ClickSFX.finished
	Globals.reset()
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
