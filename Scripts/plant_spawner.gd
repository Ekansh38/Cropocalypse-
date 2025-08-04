extends Node2D

@export var onion_scene: PackedScene
@export var chili_scene: PackedScene
@export var rice_scene: PackedScene
@export var bok_choi_scene: PackedScene

@export var spawn_bounds_top_left: Vector2
@export var spawn_bounds_bottom_right: Vector2

@export_group("Wave Timing")
@export var initial_delay: float = 2.0
@export var break_duration: float = 5.0
@export var spawn_delay: float = 0.5

@export_group("Wave Scaling")
@export var base_plants_per_wave: int = 3
@export var plant_increase_per_wave: int = 2
@export var max_plants_per_wave: int = 30
@export var starting_wave: int = 1

@export_group("Spawn Spacing")
@export var min_distance_between_plants: float = 64.0

@export_group("UI & Labels")
@export var wave_label: Label

var plant_scenes: Array[PackedScene] = []
var plants: Array[Node2D] = []
var current_wave: int
var spawning := false


func _ready():
	plant_scenes = [onion_scene, chili_scene, rice_scene, bok_choi_scene]
	current_wave = starting_wave
	start_wave_loop()


func start_wave_loop():
	await get_tree().create_timer(initial_delay).timeout
	while true:
		wave_label.text = "Wave %d" % current_wave
		await _start_wave(current_wave)
		await _wait_for_all_plants_dead()

		# Show break phase
		wave_label.text = "Break..."
		await get_tree().create_timer(break_duration).timeout

		# Start next wave
		current_wave += 1


func _start_wave(wave_number: int):
	var to_spawn = min(
		base_plants_per_wave + plant_increase_per_wave * (wave_number - 1),
		max_plants_per_wave
	)

	for i in range(to_spawn):
		spawn_plant()
		await get_tree().create_timer(spawn_delay).timeout


func _wait_for_all_plants_dead():
	while plants.size() > 0:
		await get_tree().create_timer(0.5).timeout


func spawn_plant():
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
