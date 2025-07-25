extends CharacterBody2D

var vel: Vector2 = Vector2.ZERO
var acc: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.ZERO
signal shoot_fired(global_position: Vector2, direction: Vector2)

var can_shoot: bool = true
var shoot_cooldown: float = 0.6
var last_move_key: String = "right" # Default to right

@export var inv: Inv
@export var friction := 8.0
@export var SPEED := 5000.0
@export var MAX_SPEED := 800.0

func _physics_process(delta: float) -> void:
	dir = Vector2.ZERO

	if Input.is_action_pressed("left"):
		dir.x -= 1
		last_move_key = "left"
	if Input.is_action_pressed("right"):
		dir.x += 1
		last_move_key = "right"
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1

	if dir != Vector2.ZERO:
		dir = dir.normalized()
		acc = dir * SPEED
	else:
		acc = Vector2.ZERO

	vel *= 1.0 - (friction * delta)
	vel += acc * delta

	if vel.length() > MAX_SPEED:
		vel = vel.normalized() * MAX_SPEED
	if vel.length() < 1.0:
		vel = Vector2.ZERO

	velocity = vel
	move_and_slide()

func _process(delta: float) -> void:
	rotate_guns_to_mouse()
	update_active_gun()

	if Input.is_action_just_pressed("shoot") and can_shoot:
		emit_shoot_signal()
		can_shoot = false
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true

func rotate_guns_to_mouse() -> void:
	var mouse_pos = get_global_mouse_position()

	var left_gun = $Sprite2D/LeftGun
	var right_gun = $Sprite2D/RightGun

	var left_dir = (mouse_pos - left_gun.global_position).angle()
	var right_dir = (mouse_pos - right_gun.global_position).angle()

	left_gun.rotation = left_dir + deg_to_rad(180)
	right_gun.rotation = right_dir

func update_active_gun():
	var left = $Sprite2D/LeftGun
	var right = $Sprite2D/RightGun
	left.visible = last_move_key == "left"
	right.visible = last_move_key == "right"

func emit_shoot_signal():
	var gun
	if (last_move_key == "left"): 
		gun = $Sprite2D/LeftGun 
	else: 
		gun = $Sprite2D/RightGun
	var marker = gun.get_node("Marker2D")
	var shoot_pos = marker.global_position
	var mouse_pos = get_global_mouse_position()
	var shoot_dir = (mouse_pos - shoot_pos).normalized()

	var spread = deg_to_rad(10)
	var mis_aim_angle = randf_range(-spread, spread)
	shoot_dir = shoot_dir.rotated(mis_aim_angle)

	emit_signal("shoot_fired", shoot_pos, shoot_dir)

func add_item(type):
	inv.insert(type)

func take_damage():
	Globals.player_health -= 5
	print(Globals.player_health)
