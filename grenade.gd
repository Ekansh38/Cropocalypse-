extends RigidBody2D

var camera: Camera2D

func _ready() -> void:
	$ExplodeTimer.start()
	$PinSFX.play()


func explode():
	$Sprite2D.visible = false
	camera.screen_shake(3)
	$ExplosionSFX.play()
	$ExplosionParticles.emitting = true
	await get_tree().create_timer(1).timeout
	queue_free()


@export var throw_force := 800.0

func launch(direction: Vector2) -> void:
	linear_velocity = direction * throw_force

func _on_explode_timer_timeout() -> void:
	explode()

	for body in $DamageArea.get_overlapping_bodies():
		if body.is_in_group("Plant"):
			var knockback_dir = (body.global_position - global_position).normalized()
			body.take_damage(knockback_dir * 1000, 90)
		
		elif body.is_in_group("Player"):
			body.take_damage(50) 
	
