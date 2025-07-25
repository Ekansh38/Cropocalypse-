extends Node2D

var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")


func _on_player_shoot_fired(global_position: Vector2, direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.setup(direction)
	add_child(bullet)
