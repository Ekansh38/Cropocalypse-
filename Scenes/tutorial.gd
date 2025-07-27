extends CanvasLayer



func _on_back_pressed() -> void:
	$ClickSFX.play()
	await $ClickSFX.finished

	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
