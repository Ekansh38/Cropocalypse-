extends Node2D


func _ready() -> void:
	Globals.connect("game_over", game_over)
	
func game_over():
	get_tree().paused = true

	print("GAME OVER")
	$"../Death".play()

	process_mode = Node.PROCESS_MODE_ALWAYS

	var tween = create_tween()

	var world_env = $"../WorldEnvironment".environment
	tween.tween_property(world_env, "adjustment_saturation", 0.0, 5)

	var canvas := $"../CanvasModulate"
	var current_color = canvas.color
	var target_color = current_color.darkened(0.8) 
	tween.tween_property(canvas, "color", target_color, 5)

	await tween.finished
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false

	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	
