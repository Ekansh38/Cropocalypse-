extends CanvasLayer

var is_paused = false

func _ready() -> void:
	unpause()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not is_paused:
			pause()
		else:
			unpause()
			
func pause():
	if not Globals.is_shopping and not Globals.is_cooking:
		is_paused = true
		visible = true
		get_tree().paused = true
	
func unpause():
	is_paused = false
	get_tree().paused = false
	visible = false


func _on_continue_button_pressed() -> void:
	$ClickSFX.play()
	await $ClickSFX.finished
	unpause()


func _on_options_button_pressed() -> void:
	$ClickSFX.play()
	$Options.open()
