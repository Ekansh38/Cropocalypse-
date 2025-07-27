extends Panel


func _ready():
	visible = false
	
func open():
	visible = true
	$AnimationPlayer.play("open")

func close():
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	visible = false


func _on_button_pressed() -> void:
	$ClickSFX.play()
	await $ClickSFX.finished
	close()
	


func _on_sfx_volume_2_value_changed(value: float) -> void:
	var bus_id = AudioServer.get_bus_index("SFX")
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_id, db)


func _on_music_volume_value_changed(value: float) -> void:
	var bus_id = AudioServer.get_bus_index("Music")
	var db = linear_to_db(value)

	AudioServer.set_bus_volume_db(bus_id, db)


func _on_overall_volume_value_changed(value: float) -> void:
	var bus_id = AudioServer.get_bus_index("Master")
	var db = linear_to_db(value)

	AudioServer.set_bus_volume_db(bus_id, db)
