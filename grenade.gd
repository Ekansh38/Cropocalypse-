extends RigidBody2D


func _ready() -> void:
	$ExplodeTimer.start()


func explode():
	queue_free()


@export var throw_force := 400.0

func launch(direction: Vector2) -> void:
	linear_velocity = direction * throw_force

func _on_explode_timer_timeout() -> void:
	for body in $DamageArea.get_overlapping_bodies():
		if body.is_in_group("Plant"):
			var knockback_dir = (body.global_position - global_position).normalized()
			body.take_damage(knockback_dir * 1000)
		
		elif body.is_in_group("Player"):
			body.take_damage() 
	
	explode()
