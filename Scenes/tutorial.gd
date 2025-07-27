extends CanvasLayer



func _on_back_pressed() -> void:
	$ClickSFX.play()
	visible = false
