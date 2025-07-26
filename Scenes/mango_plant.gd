extends Plant


func _ready():
	plant_drop = preload("res://Scenes/mango_drop.tscn")
	speed = 400
	$Mature.visible = false
	$GrowingParticles.visible = true
	$GrowingLight.visible = true
	$HealthBar.value = health
	$HealthBar.visible = false
	$GrowthBar.visible = true
	$GrowthBar.max_value = grow_time
	$GrowthBar.value = 0

	$DetectRadius.body_entered.connect(_on_body_entered)
	$DetectRadius.body_exited.connect(_on_body_exited)

	$Sprite2D.scale = Vector2(0.1, 0.1)
	$CollisionShape2D.scale = Vector2(0.5, 0.5)


func _physics_process(delta):
	var final_velocity = Vector2.ZERO

	# Knockback phase
	if knockback_timer > 0.0:
		knockback_timer -= delta
		if knockback_velocity.length() > 10:
			final_velocity = knockback_velocity
		else:
			knockback_velocity = Vector2.ZERO
			knockback_timer = 0.0
	else:
		knockback_velocity = Vector2.ZERO

	if state == PlantState.HOSTILE:
		var is_moving = false

		if target:
			var to_target = target.global_position - global_position
			var distance = to_target.length()
			var desired_distance = 100.0  # Distance to maintain

			if distance < desired_distance - 10:
				# Move away from player
				var direction = -to_target.normalized()
				final_velocity += direction * speed
				is_moving = true
			elif distance > desired_distance + 10:
				# Move closer to maintain distance
				var direction = to_target.normalized()
				final_velocity += direction * speed
				is_moving = true
			else:
				final_velocity = Vector2.ZERO
			mature_sprite.flip_h = final_velocity.x < -0.1
  # Stay in place
		else:
			wander_timer -= delta
			if wander_timer <= 0.0:
				wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
				wander_timer = WANDER_CHANGE_INTERVAL
			final_velocity += wander_direction * WANDER_SPEED
			is_moving = true
			if mature_sprite.visible:
				mature_sprite.play("walk")
				mature_sprite.flip_h = wander_direction.x < -0.1

		if mature_sprite.visible and not is_moving:
			mature_sprite.stop()

	move_and_collide(final_velocity * delta)

func take_damage(knockback_velocity_input: Vector2 = Vector2.ZERO):
	if state != PlantState.HOSTILE:
		queue_free()

	health -= 25
	$HitParticles.emitting = true
	$HealthBar.value = health

	if knockback_velocity_input != Vector2.ZERO:
		knockback_velocity = knockback_velocity_input
		knockback_timer = KNOCKBACK_DURATION

	if health <= 0:
		var plant_drop_obj = plant_drop.instantiate()
		plant_drop_obj.global_position = global_position
		get_tree().current_scene.add_child(plant_drop_obj)
		queue_free()

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
			growth_bar.visible = false
			health_bar.visible = true

			seedling_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = false
			mature_sprite.visible = true
			mature_sprite.play("walk")

			main_shape.scale = Vector2(1, 6)
			main_shape.position = Vector2(0, 0)

			# Reparent to ActiveEnemies
			var world = get_tree().current_scene
			var new_parent = world.get_node("ActiveEnemies")
			if new_parent:
				get_parent().remove_child(self)
				new_parent.add_child(self)
				self.global_position = self.global_position

			# Set target if in range
			for body in $DetectRadius.get_overlapping_bodies():
				if body.is_in_group("Player"):
					target = body
					break
