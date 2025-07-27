extends CanvasLayer


func _on_play_pressed() -> void:
	$ClickSFX.play()
	await $ClickSFX.finished
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_freeplay_pressed() -> void:
	$ClickSFX.play()
	await $ClickSFX.finished

	Globals.money = 1000
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_options_pressed() -> void:
	$ClickSFX.play()
	$Options2.open()


func _on_controls_pressed() -> void:
	$ClickSFX.play()
	$Tutorial.visible = true
