extends Plant

func _ready():
	if camera == null:
		camera = get_tree().current_scene.get_node("Player/Camera2D")
	plant_drop = preload("res://Scenes/mango_drop.tscn")
	speed = 400

	# Run base class setup
	super._ready()


func transition_to_state(new_state: PlantState) -> void:
	state = new_state

	match new_state:
		PlantState.MEDIUM:
			$GrowingParticles.visible = true
			$GrowingLight.visible = true
			seedling_sprite.visible = false
			medium_sprite.visible = true
			large_sprite.visible = false
			main_shape.scale = Vector2(1, 4)
			main_shape.position = Vector2(0, 25)

		PlantState.LARGE:
			$GrowingParticles.visible = true
			$GrowingLight.visible = true
			seedling_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = true
			main_shape.scale = Vector2(1, 1)
			main_shape.position = Vector2(0, 52.0)

		PlantState.HOSTILE:
			$GrowingParticles.visible = false
			$GrowingLight.visible = false
			growth_bar.visible = false
			health_bar.visible = true

			seedling_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = false
			mature_sprite.visible = true
			mature_sprite.play("walk")

			main_shape.scale = Vector2(2, 7)
			main_shape.position = Vector2(0, 0)

			# Move into ActiveEnemies node
			var world = get_tree().current_scene
			var new_parent = world.get_node("ActiveEnemies")
			if new_parent:
				get_parent().remove_child(self)
				new_parent.add_child(self)
				self.global_position = self.global_position  # Maintain position

			# Acquire target if player already in range
			for body in $DetectRadius.get_overlapping_bodies():
				if body.is_in_group("Player"):
					target = body
					break
