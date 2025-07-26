extends Node2D

@export var mango_scene: PackedScene
@export var min_spawn_delay := 3.0
@export var max_spawn_delay := 7.0

@onready var active_mangos = $"../ActiveEnemies"

var occupied_pairs := {}

func _ready():
	schedule_next_spawn()

func schedule_next_spawn():
	var delay = randf_range(min_spawn_delay, max_spawn_delay)
	if get_tree():
		await get_tree().create_timer(delay).timeout
	spawn_random_mango()
	schedule_next_spawn()

func spawn_random_mango():
	if active_mangos.get_child_count() >= 3:
		return # too many active mangos

	var all_pairs = get_children()
	var available_pairs = all_pairs.filter(func(pair):
		return not occupied_pairs.has(pair)
	)

	if available_pairs.is_empty():
		return

	var chosen_pair = available_pairs[randi() % available_pairs.size()]
	var start = chosen_pair.get_node("Start")

	var mango = mango_scene.instantiate()
	mango.global_position = start.global_position

	chosen_pair.add_child(mango)
	mango.set("spawn_pair", chosen_pair)

	occupied_pairs[chosen_pair] = mango
	mango.connect("tree_exited", Callable(self, "_on_mango_removed").bind(chosen_pair))

func _on_mango_removed(pair):
	if pair in occupied_pairs:
		occupied_pairs.erase(pair)
