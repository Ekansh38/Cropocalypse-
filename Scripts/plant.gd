extends CharacterBody2D
class_name Plant

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer := 0.0
const KNOCKBACK_DURATION := 0.3
enum PlantState { SEEDLING, MEDIUM, LARGE, HOSTILE }
var is_alive = true
var is_attack_playing = false

var plant_drop: PackedScene = preload("res://Scenes/plant_drop.tscn")
@onready var mature_sprite = $Mature
var state = PlantState.SEEDLING
var grow_time = 8.0
var grow_timer = 0.0
@onready var camera = $"../../Player/Camera2D"
var speed = 300
var target: Node2D = null
var health = 100

var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var WANDER_SPEED = 90.0
const WANDER_CHANGE_INTERVAL = 2.0

func _ready():
	$Shadow.visible = false

	$Mature.visible = false
	$GrowingParticles.visible = true
	$GrowingLight.visible = true
	$HealthBar.value = health
	$HealthBar.visible = false
	$GrowthBar.visible = true
	$GrowthBar.max_value = grow_time
	$GrowthBar.value = 0
	$CollisionShape2D.disabled = false
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
			$CollisionShape2D.disabled = false
			$Shadow.visible = false
		PlantState.LARGE:
			$GrowingParticles.visible = true
			$GrowingLight.visible = true
			seedling_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = true
			$CollisionShape2D.disabled = false
			$Shadow.visible = true

		PlantState.HOSTILE:
			$Shadow.visible = true

			if self is OnionPlant:
				(self as OnionPlant).start_crying()
			$GrowingParticles.visible = false
			$GrowingLight.visible = false
			growth_bar.visible = false
			health_bar.visible = true
			$CollisionShape2D.disabled = false
			seedling_sprite.visible = false
			medium_sprite.visible = false
			large_sprite.visible = false
			mature_sprite.visible = true
			if not is_attack_playing:
				mature_sprite.play("walk")


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
			var to_target = target.global_position - global_position
			var distance = to_target.length()
			var desired_distance = 100.0  

			if distance < desired_distance - 10:
				var direction = -to_target.normalized()
				final_velocity += direction * speed
				is_moving = true
			elif distance > desired_distance + 10:
				var direction = to_target.normalized()
				final_velocity += direction * speed
				is_moving = true
			else:
				final_velocity = Vector2.ZERO
			
			mature_sprite.flip_h = final_velocity.x < -0.1
 # Stay in place
		else:
			wander_timer -= delta
			if wander_timer <= 0.0:
				wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
				wander_timer = WANDER_CHANGE_INTERVAL
			final_velocity += wander_direction * WANDER_SPEED
			is_moving = true

		if mature_sprite.visible:
			if is_moving:
				if target:
					if mature_sprite.animation != "walk" and not is_attack_playing:
						mature_sprite.play("walk")
				else:
					if mature_sprite.animation != "walk_slow":
						if "walk_slow" in mature_sprite.sprite_frames.get_animation_names():
							mature_sprite.play("walk_slow")

			mature_sprite.flip_h = final_velocity.x < -0.1
		
					
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
		
func take_damage(knockback_velocity_input: Vector2 = Vector2.ZERO, damage: int = 25):
	if state != PlantState.HOSTILE:
		queue_free()

	health -= damage
	$HitParticles.emitting = true
	$HealthBar.value = health
	camera.screen_shake()

	if knockback_velocity_input != Vector2.ZERO:
		knockback_velocity = knockback_velocity_input
		knockback_timer = KNOCKBACK_DURATION

	if health <= 0 and is_alive:
		var plant_drop_obj = plant_drop.instantiate()
		plant_drop_obj.global_position = global_position
		var plant_drops = $"../../PlantDrops"
		
		


		plant_drops.add_child(plant_drop_obj)
		$Mature.visible = false
		$HealthBar.visible = false
		$CollisionShape2D.disabled = true
		$DetectRadius/CollisionShape2D.disabled = true
		$AttackArea/CollisionShape2D.disabled = true
		$Shadow.visible = false
		is_alive = false
		var sounds = [$Death1, $Death2, $Death3]
		var random_sound: AudioStreamPlayer2D = sounds[randi() % sounds.size()]
		random_sound.play()
		await random_sound.finished
		queue_free()


func _on_mature_animation_finished() -> void:
	is_attack_playing = false
