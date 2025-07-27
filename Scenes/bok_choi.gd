extends Plant

@onready var wind_body = $WindBody
@onready var wind_arm = $WindArm
@onready var punch_body = $PunchBody
@onready var punch_arm = $PunchArm

var is_attacking = false
var attack_cooldown := 1.0
var attack_cooldown_timer := 0.0

func _ready():
	super._ready()  # Call parent's _ready if needed
	plant_drop = preload("res://Scenes/bok_choi_drop.tscn")
	# Hide arms initially
	wind_body.visible = false
	wind_arm.visible = false
	punch_body.visible = false
	punch_arm.visible = false
	health = 150
	$HealthBar.value = health


func _physics_process(delta):
	super._physics_process(delta)  # Keep movement and knockback from parent

	if state == PlantState.HOSTILE and target != null:
		attack_cooldown_timer -= delta

		var dist = global_position.distance_to(target.global_position)
		if dist > 90 and dist < 110 and not is_attacking and attack_cooldown_timer <= 0:
			start_attack()
			
			
func start_attack():
	is_attacking = true
	attack_cooldown_timer = attack_cooldown

	# Only show punch visuals
	wind_body.visible = false
	wind_arm.visible = false
	punch_body.visible = true
	punch_arm.visible = true

	# Point punch arm at player (it points left)
	var dir = (target.global_position - punch_arm.global_position).angle()
	punch_arm.rotation = dir - deg_to_rad(180)

	# Play sound and apply damage instantly
	if state == PlantState.HOSTILE:
		for area in $AttackArea.get_overlapping_areas():
			if area.is_in_group("player_attack_area"):
				if area.has_method("take_damage"):
					area.take_damage()
					$"SlapPlayer".play()
					break

	if get_tree():
		await get_tree().create_timer(0.2).timeout

	# Hide everything after punch
	punch_body.visible = false
	punch_arm.visible = false
	is_attacking = false
