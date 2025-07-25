extends CharacterBody2D

enum PlantState { SEEDLING, HOSTILE }

var plant_drop: PackedScene = preload("res://Scenes/plant_drop.tscn")

var state = PlantState.SEEDLING
var grow_time = 7.0
var speed = 300
var target: Node2D = null
var health = 100

var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
const WANDER_SPEED = 90.0
const WANDER_CHANGE_INTERVAL = 2.0

func _ready():
	$HealthBar.value = health
	$HealthBar.visible = false

	$DetectRadius.body_entered.connect(_on_body_entered)
	$DetectRadius.body_exited.connect(_on_body_exited)

	$Sprite2D.scale = Vector2(0.1, 0.1)
	$CollisionShape2D.scale = Vector2(0.5, 0.5)

	await get_tree().create_timer(grow_time).timeout
	grow_into_enemy()

func grow_into_enemy():
	$HealthBar.visible = true
	state = PlantState.HOSTILE
	$Sprite2D.scale = Vector2(0.2, 0.2)
	$CollisionShape2D.scale = Vector2(1, 1)
	for body in $DetectRadius.get_overlapping_bodies():
		if body.is_in_group("Player"):
			target = body
			break

func _physics_process(delta):
	if state != PlantState.HOSTILE:
		return

	if target:
		var direction = (target.global_position - global_position).normalized()
		var motion = direction * speed * delta
		move_and_collide(motion)
	else:
		wander_timer -= delta
		if wander_timer <= 0.0:
			wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
			wander_timer = WANDER_CHANGE_INTERVAL
		var motion = wander_direction * WANDER_SPEED * delta
		move_and_collide(motion)

func _on_body_entered(body: Node) -> void:
	if state == PlantState.HOSTILE and body.is_in_group("Player"):
		target = body

func _on_body_exited(body: Node) -> void:
	if body == target:
		target = null
		
func take_damage():
	if state == PlantState.SEEDLING:
		queue_free()
	health -= 25
	$HealthBar.value = health
	if health <= 0:
		var plant_drop_obj = plant_drop.instantiate()
		plant_drop_obj.global_position = global_position
		get_tree().current_scene.add_child(plant_drop_obj)
		queue_free()
