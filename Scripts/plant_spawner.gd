extends Node2D

@export var plant_scene: PackedScene
@export var chili_scene: PackedScene
@export var rice_scene: PackedScene
@export var bok_choi_scene: PackedScene

@export var spawn_interval: float = 5.0
@export var spawn_interval_variance: float = 2.0
@export var max_plants: int = 10
@export var min_distance_between_plants: float = 64.0

@export var spawn_bounds_top_left: Vector2
@export var spawn_bounds_bottom_right: Vector2

var plants: Array[Node2D] = []
var plant_scenes: Array[PackedScene] = []

func _ready():
	# Add all plant scenes to the list
	plant_scenes = [
		#plant_scene,
		#chili_scene,
		rice_scene,
		#bok_choi_scene
	]
	spawn_plant_timer()

func spawn_plant_timer():
	spawn_plant()
	var delay = spawn_interval + randf_range(-spawn_interval_variance, spawn_interval_variance)
	delay = max(0.5, delay)
	await get_tree().create_timer(delay).timeout
	spawn_plant_timer()

func spawn_plant():
	if plants.size() >= max_plants:
		return

	var pos = get_random_point_in_bounds()
	if pos == null:
		return

	for plant in plants:
		if plant.global_position.distance_to(pos) < min_distance_between_plants:
			return

	var plant_scene = plant_scenes.pick_random()
	var plant = plant_scene.instantiate()
	plant.global_position = pos
	add_child(plant)
	plants.append(plant)

	plant.tree_exited.connect(func():
		plants.erase(plant)
	)

func get_random_point_in_bounds() -> Vector2:
	return Vector2(
		randf_range(spawn_bounds_top_left.x, spawn_bounds_bottom_right.x),
		randf_range(spawn_bounds_top_left.y, spawn_bounds_bottom_right.y)
	)
