extends CharacterBody2D
var is_aiming_grenade: bool = false
@onready var aim_line := $AimLine2D 
var vel: Vector2 = Vector2.ZERO
var acc: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.ZERO
signal shoot_fired(global_position: Vector2, direction: Vector2)

var can_shoot: bool = true
var shoot_cooldown: float = 0.6
var last_move_key: String = "right" # Default to right
signal grenade_thrown(global_position: Vector2, direction: Vector2, with_launcher: bool)
@export var inv: Inv
@export var friction := 8.0
@export var SPEED := 5000.0
@export var MAX_SPEED := 800.0

func _ready() -> void:
	Globals.connect("update_active_gun", update_active_gun)


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
	#var collision = move_and_collide(vel * delta)
	#if collision:
		#vel = Vector2.ZERO

func _process(delta: float) -> void:
	rotate_guns_to_mouse()
	
	var hunger_drain = 0.4 * delta
	var thirst_drain = 0.6 * delta

	if dir != Vector2.ZERO:
		hunger_drain *= 3.0
		thirst_drain *= 3.0

	Globals.player_hunger -= hunger_drain
	Globals.player_thirst -= thirst_drain

	Globals.player_hunger = clamp(Globals.player_hunger, 0, 100)
	Globals.player_thirst = clamp(Globals.player_thirst, 0, 100)
	
	if Input.is_action_pressed("grenade") and not Globals.is_hovering_on_ui:
		is_aiming_grenade = true
		update_grenade_aim_line()
	elif is_aiming_grenade:
		is_aiming_grenade = false
		aim_line.clear_points()
		if Globals.grenades > 0:
			Globals.grenades -= 1
			var using_left = $Player/LeftGun.visible
			var marker
			if using_left:
				marker = $Player/LeftGun/Marker2D
			else:
				marker = $Player/RightGun/Marker2D
			var throw_pos = marker.global_position
			var mouse_pos = get_global_mouse_position()
			var throw_dir = (mouse_pos - throw_pos).normalized()
			emit_signal("grenade_thrown", throw_pos, throw_dir, false)		
	if Input.is_action_just_pressed("shoot") and can_shoot and not Globals.is_hovering_on_ui and not Globals.is_cooking and not Globals.is_shopping:
		if Globals.active_gun == "Grenade Launcher":
			emit_grenade_launcher_signal()
		else:
			emit_shoot_signal()
		
		can_shoot = false
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true
		
	
	if dir != Vector2.ZERO:
		if not $Player.is_playing() or $Player.animation != "walk":
			$Player.visible = true
			$Player.play("walk")
			$WalkingSFX.play()
			$Sprite2D.visible = false

	else:
		$WalkingSFX.stop()

		$Player.stop()
		$Player.visible = false
		$Sprite2D.visible = true
	
	
	if dir.x < 0:
		$Player.flip_h = false
	elif dir.x > 0:
		$Player.flip_h = true
		
		
func emit_grenade_signal():
	if Globals.grenades > 0:
		Globals.grenades -= 1
		var using_left = $Player/LeftGun.visible
		var marker
		if using_left:
			marker = $Player/LeftGun/Marker2D
		else:
			marker = $Player/RightGun/Marker2D
		
		var throw_pos = marker.global_position
		var mouse_pos = get_global_mouse_position()
		var throw_dir = (mouse_pos - throw_pos).normalized()
		
		emit_signal("grenade_thrown", throw_pos, throw_dir, false)
func emit_grenade_launcher_signal():

	var using_left = $Player/LeftGun.visible
	var marker
	if using_left:
		marker = $Player/LeftGun/Marker2D
	else:
		marker = $Player/RightGun/Marker2D
	
	var throw_pos = marker.global_position
	var mouse_pos = get_global_mouse_position()
	var throw_dir = (mouse_pos - throw_pos).normalized()
		
	emit_signal("grenade_thrown", throw_pos, throw_dir, true)



func rotate_guns_to_mouse() -> void:
	var mouse_pos = get_viewport().get_mouse_position()

	var screen_center_x = get_viewport_rect().size.x / 2
	var left_gun = $Player/LeftGun
	var right_gun = $Player/RightGun
	
	var other_left_gun = $Sprite2D/LeftGun
	var other_right_gun = $Sprite2D/RightGun

	if mouse_pos.x < screen_center_x:
		$Sprite2D.flip_h = false

		left_gun.visible = true
		right_gun.visible = false
		other_left_gun.visible = true
		other_right_gun.visible = false

		var dir = (get_global_mouse_position() - left_gun.global_position).angle()
		left_gun.rotation = dir + deg_to_rad(180)
		other_left_gun.rotation = dir + deg_to_rad(180)

	else:
		$Sprite2D.flip_h = true
		left_gun.visible = false
		right_gun.visible = true
		other_left_gun.visible = false
		other_right_gun.visible = true

		var dir = (get_global_mouse_position() - right_gun.global_position).angle()
		right_gun.rotation = dir
		other_right_gun.rotation = dir

		
		


func emit_shoot_signal():
	$ShotSFX.pitch_scale = randf_range(0.85, 1.15)
	$ShotSFX.play()
	var using_left = $Player/LeftGun.visible
	var marker
	if using_left:
		marker = $Player/LeftGun/Marker2D
	else:
		marker = $Player/RightGun/Marker2D
	var shoot_pos = marker.global_position
	var mouse_pos = get_global_mouse_position()
	var shoot_dir = (mouse_pos - shoot_pos).normalized()

	var spread = deg_to_rad(10)
	var mis_aim_angle = randf_range(-spread, spread)
	shoot_dir = shoot_dir.rotated(mis_aim_angle)

	emit_signal("shoot_fired", shoot_pos, shoot_dir)

func add_item(type):
	inv.insert(type)

func take_damage(damage: int = 3):
	$HitParticles.emitting = true
	$Camera2D.screen_shake(2)
	Globals.player_health -= damage
	print(Globals.player_health)


func change_control_label(message):
	$ControlLabel.text = message
	
	
func update_grenade_aim_line():
	var marker: Marker2D
	if $Player/LeftGun.visible:
		marker = $Player/LeftGun/Marker2D
	else:
		marker = $Player/RightGun/Marker2D

	var start_pos = marker.global_position
	var mouse_pos = get_global_mouse_position()

	var max_range = 400.0
	var diff = mouse_pos - start_pos
	var dist = diff.length()
	var clamped_dir = diff.normalized()

	var target_pos: Vector2
	if dist > max_range:
		target_pos = start_pos + clamped_dir * max_range
	else:
		target_pos = mouse_pos

	var arc_height = -150.0
	var steps = 25
	var points: Array[Vector2] = []

	for i in range(steps + 1):
		var t = i / float(steps)
		var p = start_pos.lerp(target_pos, t)
		p.y += arc_height * sin(PI * t)
		points.append(aim_line.to_local(p))

	aim_line.points = points



func update_active_gun():
	if Globals.has_speed_boots == true:
		SPEED = 8000
	else:
		SPEED = 5000
	
	if Globals.active_gun == "Pistol" and "Pistol" in Globals.available_guns:
		shoot_cooldown = 0.6
		var pistol_texture = preload("res://Assets/gjpistol.png")

		$Sprite2D/LeftGun.texture = pistol_texture
		$Sprite2D/RightGun.texture = pistol_texture
		$Player/LeftGun.texture = pistol_texture
		$Player/RightGun.texture = pistol_texture

		# Right guns flipped
		$Sprite2D/RightGun.flip_h = true
		$Player/RightGun.flip_h = true
		$Sprite2D/RightGun.scale = Vector2(1, 1)
		$Player/RightGun.scale = Vector2(1, 1)

		# Left guns normal
		$Sprite2D/LeftGun.flip_h = false
		$Player/LeftGun.flip_h = false
		$Sprite2D/LeftGun.scale = Vector2(1, 1)
		$Player/LeftGun.scale = Vector2(1, 1)
		
	elif Globals.active_gun == "Shotgun" and "Shotgun" in Globals.available_guns:
		shoot_cooldown = 1
		var shotgun_texture = preload("res://Assets/weapons/shotgunhold.png")

		$Sprite2D/LeftGun.texture = shotgun_texture
		$Sprite2D/RightGun.texture = shotgun_texture
		$Player/LeftGun.texture = shotgun_texture
		$Player/RightGun.texture = shotgun_texture

		# Left guns flipped
		$Sprite2D/LeftGun.flip_h = true
		$Player/LeftGun.flip_h = true
		$Sprite2D/LeftGun.scale = Vector2(0.5, 0.5)
		$Player/LeftGun.scale = Vector2(0.5, 0.5)

		# Right guns normal
		$Sprite2D/RightGun.flip_h = false
		$Player/RightGun.flip_h = false
		$Sprite2D/RightGun.scale = Vector2(0.5, 0.5)
		$Player/RightGun.scale = Vector2(0.5, 0.5)
		
	elif Globals.active_gun == "Grenade Launcher"  and "Grenade Launcher" in Globals.available_guns:
		shoot_cooldown = 1.5
		var shotgun_texture = preload("res://Assets/weapons/launcherhold.png")

		$Sprite2D/LeftGun.texture = shotgun_texture
		$Sprite2D/RightGun.texture = shotgun_texture
		$Player/LeftGun.texture = shotgun_texture
		$Player/RightGun.texture = shotgun_texture

		# Left guns flipped
		$Sprite2D/LeftGun.flip_h = true
		$Player/LeftGun.flip_h = true
		$Sprite2D/LeftGun.scale = Vector2(0.5, 0.5)
		$Player/LeftGun.scale = Vector2(0.5, 0.5)

		# Right guns normal
		$Sprite2D/RightGun.flip_h = false
		$Player/RightGun.flip_h = false
		$Sprite2D/RightGun.scale = Vector2(0.5, 0.5)
		$Player/RightGun.scale = Vector2(0.5, 0.5)
	elif Globals.active_gun == "AK47"  and "AK47" in Globals.available_guns:
		shoot_cooldown = 0
		var shotgun_texture = preload("res://Assets/weapons/akhold.png")

		$Sprite2D/LeftGun.texture = shotgun_texture
		$Sprite2D/RightGun.texture = shotgun_texture
		$Player/LeftGun.texture = shotgun_texture
		$Player/RightGun.texture = shotgun_texture

		# Left guns flipped
		$Sprite2D/LeftGun.flip_h = true
		$Player/LeftGun.flip_h = true
		$Sprite2D/LeftGun.scale = Vector2(0.5, 0.5)
		$Player/LeftGun.scale = Vector2(0.5, 0.5)

		# Right guns normal
		$Sprite2D/RightGun.flip_h = false
		$Player/RightGun.flip_h = false
		$Sprite2D/RightGun.scale = Vector2(0.5, 0.5)
		$Player/RightGun.scale = Vector2(0.5, 0.5)

		

		
