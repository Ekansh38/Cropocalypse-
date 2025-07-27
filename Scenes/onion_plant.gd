extends Plant
class_name OnionPlant

var cry_sounds: Array[AudioStreamPlayer2D]
var current_cry: AudioStreamPlayer2D = null
var is_crying := false

func _ready():
	play_random_cry()
	cry_sounds = [$Cry1, $Cry2, $Cry3]

	speed = 500
	WANDER_SPEED = 300.0
	$Shadow.visible = false

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
	
	plant_drop = preload("res://Scenes/onion_drop.tscn")

func start_crying():
	if is_crying:
		return
	is_crying = true
	play_random_cry()

func play_random_cry():
	if not is_crying:
		return
	if current_cry and current_cry.playing:
		current_cry.stop()
	current_cry = cry_sounds[randi() % cry_sounds.size()]
	current_cry.play()
	current_cry.finished.connect(_on_cry_finished, CONNECT_ONE_SHOT)

func _on_cry_finished():
	play_random_cry()
