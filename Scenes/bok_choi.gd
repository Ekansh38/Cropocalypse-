extends Plant

@onready var wind_body = $WindBody
@onready var wind_arm = $WindArm
@onready var punch_body = $PunchBody
@onready var punch_arm = $PunchArm
@onready var attack_timer := Timer.new()

var is_attacking = false
var wind_up_duration := 0.2
var attack_cooldown := 1.0
var attack_cooldown_timer := 0.0

func _ready():
	super._ready()  # Call parent's _ready if needed
	plant_drop = preload("res://Scenes/bok_choi_drop.tscn")
	add_child(attack_timer)
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)

	# Hide arms initially
	wind_body.visible = false
	wind_arm.visible = false
	punch_body.visible = false
	punch_arm.visible = false
	

func _physics_process(delta):
	super._physics_process(delta)  # Keep movement and knockback from parent

	if state == PlantState.HOSTILE and target:
		attack_cooldown_timer -= delta

		if global_position.distance_to(target.global_position) < 100 and not is_attacking and attack_cooldown_timer <= 0:
			start_attack()

func start_attack():
	is_attacking = true
	attack_cooldown_timer = attack_cooldown

	# Show wind-up sprites
	wind_body.visible = true
	wind_arm.visible = true
	punch_body.visible = false
	punch_arm.visible = false

	# Point wind arm at player (it points up)
	var dir = (target.global_position - wind_arm.global_position).angle()
	wind_arm.rotation = dir - deg_to_rad(90)

	attack_timer.start(wind_up_duration)

func _on_attack_timer_timeout():
	if not target:
		is_attacking = false
		return

	# Switch to punch visuals
	wind_body.visible = false
	wind_arm.visible = false
	punch_body.visible = true
	punch_arm.visible = true

	# Point punch arm at player (it points left)
	var dir = (target.global_position - punch_arm.global_position).angle()
	punch_arm.rotation = dir - deg_to_rad(180)



	if state == PlantState.HOSTILE:
		for area in $AttackArea.get_overlapping_areas():
			if area.is_in_group("player_attack_area"):
				if area.has_method("take_damage"):
					area.take_damage()
					$"SlapPlayer".play()
					break

	await get_tree().create_timer(0.2).timeout

	# Hide everything after punch
	punch_body.visible = false
	punch_arm.visible = false
	is_attacking = false
