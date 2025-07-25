extends Camera2D

var shake_strength := 0.0
var shake_decay := 5.0
var shake_max_offset := 10.0
var original_offset := Vector2.ZERO

func _ready():
	original_offset = offset

func _process(delta):
	if shake_strength > 0:
		offset = original_offset + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_strength * shake_max_offset
		shake_strength = max(shake_strength - shake_decay * delta, 0.0)
	else:
		offset = original_offset

func screen_shake(strength: float = 1.0):
	shake_strength = strength
