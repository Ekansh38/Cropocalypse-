extends RigidBody2D


func _ready() -> void:
	$ExplodeTimer.start()


func _on_explode_timer_timeout() -> void:
	queue_free()
