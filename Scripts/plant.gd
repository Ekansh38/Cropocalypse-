extends CharacterBody2D
class_name Plant

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer := 0.0
const KNOCKBACK_DURATION := 0.3
enum PlantState { SEEDLING, MEDIUM, LARGE, HOSTILE }

var plant_drop: PackedScene = preload("res://Scenes/plant_drop.tscn")
@onready var mature_sprite = $Mature
var state = PlantState.SEEDLING
var grow_time = 7.0
var grow_timer = 0.0
@onready var camera = $"../Player/Camera2D"
var speed = 300
var target: Node2D = null
var health = 100

var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
const WANDER_SPEED = 90.0
const WANDER_CHANGE_INTERVAL = 2.0

func _ready():
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

@onready var seedling_sprite = $Sprite2D
@onready var medium_sprite = $Medium
@onready var large_sprite = $Large
@onready var main_shape = $CollisionShape2D

@onready var growth_bar = $GrowthBar
@onready var health_bar = $HealthBar

func _process(delta):
	if state == PlantState.HOSTILE:
		return

	grow_timer += delta
	growth_bar.value = grow_timer

	if state == PlantState.SEEDLING and grow_timer >= grow_time * 0.33:
		transition_to_state(PlantState.MEDIUM)

	elif state == PlantState.MEDIUM and grow_timer >= grow_time * 0.66:
		transition_to_state(PlantState.LARGE)

	elif state == PlantState.LARGE and grow_timer >= grow_time:
		transition_to_state(PlantState.HOSTILE)

func transition_to_state(new_state: PlantState) -> void:
	state = new_state

	match new_state:
		PlantState.MEDIUM:
			$GrowingParticles.visible = true
			$GrowingLight.visible = true
			seedling_sprite.visible = false
			medium_sprite.visible = true
			large_sprite.visible = false
			main_shape.scale = Vector2(1, 4)
			main_shape.position = Vector2(0, 25)

		PlantState.LARGE:
			$GrowingParticles.visible = true
			$GrowingLight.visible = true
			seedling_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = true
			main_shape.scale = Vector2(1, 1)
			main_shape.position = Vector2(0, 52.0)

		PlantState.HOSTILE:
			$GrowingParticles.visible = false
			$GrowingLight.visible = false
			growth_bar.visible = false
			health_bar.visible = true

			seedling_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = false
			mature_sprite.visible = true
			mature_sprite.play("walk")

			main_shape.scale = Vector2(2, 7)
			main_shape.position = Vector2(0, 0)

			for body in $DetectRadius.get_overlapping_bodies():
				if body.is_in_group("Player"):
					target = body
					break					
										
func grow_into_enemy():
	$GrowthBar.visible = false
	$HealthBar.visible = true
	state = PlantState.HOSTILE

	$Sprite2D.scale = Vector2(0.2, 0.2)
	$CollisionShape2D.scale = Vector2(1, 1)

	for body in $DetectRadius.get_overlapping_bodies():
		if body.is_in_group("Player"):
			target = body
			break

func _physics_process(delta):
	var final_velocity = Vector2.ZERO

	# Knockback phase
	if knockback_timer > 0.0:
		knockback_timer -= delta
		if knockback_velocity.length() > 10: # Threshold to stop micro jitter
			final_velocity = knockback_velocity
		else:
			knockback_velocity = Vector2.ZERO
			knockback_timer = 0.0
	else:
		knockback_velocity = Vector2.ZERO

	if state == PlantState.HOSTILE:
		var is_moving = false

		if target:
			var direction = (target.global_position - global_position).normalized()
			final_velocity += direction * speed
			is_moving = true

			if mature_sprite.visible:
				mature_sprite.play("walk")
				mature_sprite.flip_h = direction.x < -0.1
		else:
			wander_timer -= delta
			if wander_timer <= 0.0:
				wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
				wander_timer = WANDER_CHANGE_INTERVAL
			final_velocity += wander_direction * WANDER_SPEED
			is_moving = true

			if mature_sprite.visible:
				mature_sprite.play("walk_slow")
				mature_sprite.flip_h = wander_direction.x < -0.1

		if mature_sprite.visible and not is_moving:
			mature_sprite.stop()
			
	var collision = move_and_collide(final_velocity * delta)
	
	
	
	if knockback_timer > 0.0 and collision and collision.get_collider().is_in_group("Plant"):
		var normal = collision.get_normal()
		knockback_velocity = knockback_velocity.bounce(normal) * 0.5
			
func _on_body_entered(body: Node) -> void:
	if state == PlantState.HOSTILE and body.is_in_group("Player"):
		target = body

func _on_body_exited(body: Node) -> void:
	if body == target:
		target = null
		
func take_damage(knockback_velocity_input: Vector2 = Vector2.ZERO):
	if state != PlantState.HOSTILE:
		queue_free()

	health -= 25
	$HitParticles.emitting = true
	$HealthBar.value = health
	camera.screen_shake()

	if knockback_velocity_input != Vector2.ZERO:
		knockback_velocity = knockback_velocity_input
		knockback_timer = KNOCKBACK_DURATION

	if health <= 0:
		var plant_drop_obj = plant_drop.instantiate()
		plant_drop_obj.global_position = global_position
		get_tree().current_scene.add_child(plant_drop_obj)
		queue_free()
