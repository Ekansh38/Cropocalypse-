extends CharacterBody2D

enum PlantState { SEEDLING, HOSTILE }

var state = PlantState.SEEDLING
var grow_time = 5.0
var speed = 300

#@onready var anim_sprite = $AnimatedSprite2D

#func _ready():
	#anim_sprite.play("seedling")
	#await get_tree().create_timer(grow_time).timeout
	#grow_into_enemy()

func grow_into_enemy():
	state = PlantState.HOSTILE
	#anim_sprite.play("grown")

func _physics_process(delta):
	if state == PlantState.HOSTILE:
		velocity = get_direction_to_player() * speed
		move_and_slide()

func get_direction_to_player() -> Vector2:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO
