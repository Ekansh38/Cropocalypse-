extends Plant


func _ready():
	$Mature.visible = false
	$GrowingParticles.visible = true
	$GrowingLight.visible = true
	$HealthBar.value = health
	$HealthBar.visible = false
	$GrowthBar.visible = true
	$GrowthBar.max_value = grow_time
	$GrowthBar.value = 0
	$Shadow.visible = false

	$DetectRadius.body_entered.connect(_on_body_entered)
	$DetectRadius.body_exited.connect(_on_body_exited)

	$Sprite2D.scale = Vector2(0.1, 0.1)
	$CollisionShape2D.scale = Vector2(0.5, 0.5)
	plant_drop = preload("res://Scenes/chili_drop.tscn")
