extends StaticBody2D

@onready var light = $PointLight2D
@onready var tween := create_tween()

func _ready() -> void:
	light.energy = 0

func light_on():
	tween.kill()
	tween = create_tween()
	tween.tween_property(light, "energy", 0.6, 0.5)  # animate to 0.6 in 0.5 seconds

func light_off():
	tween.kill()
	tween = create_tween()
	tween.tween_property(light, "energy", 0.0, 0.5)
