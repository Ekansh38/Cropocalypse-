extends Node2D

var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
var grenade_scene: PackedScene = preload("res://grenade.tscn")

func _on_player_shoot_fired(global_position: Vector2, direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.setup(direction)
	add_child(bullet)


func _on_player_grenade_thrown(global_position: Vector2, direction: Vector2, with_launcher: bool) -> void:
	var grenade_power = 800
	if with_launcher and "Grenade Launcher" in Globals.available_guns:
		grenade_power = 1600
	var grenade = grenade_scene.instantiate()
	grenade.global_position = global_position
	grenade.camera = $Player/Camera2D
	if grenade.has_method("launch"):
		grenade.launch(direction, grenade_power)

	$Grenades.add_child(grenade)
