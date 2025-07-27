extends CanvasLayer

@export var inventory: Control
@export var recipe_book: CanvasLayer
@export var cooking_ui: CanvasLayer

var outline_color = Color("#ffffff")
var shade_color = Color("#ffffff15")


var is_open_recipe_book = false
var is_inv_open = false
func _ready() -> void:
	reset_outlines()
	
	Globals.active_gun = "Pistol"
	$Pistol.material.set_shader_parameter("outline_color", outline_color)
	$Pistol.material.set_shader_parameter("shade_color", shade_color)
	Globals.connect("update_stats", update_stats)
	update_stats()
	
func update_stats():
	$Money.text = str(Globals.money)
	$GrenadeAmount.text = str(Globals.grenades)
	$HealthBar.value = Globals.player_health
	$ThirstBar.value = Globals.player_thirst
	$HungerBar.value = Globals.player_hunger
	
	for gun_name in ["Pistol", "Shotgun", "AK47", "GrenadeLauncher"]:
		var gun_node = get_node(gun_name)
		if gun_node.material is ShaderMaterial:
			if gun_name == "GrenadeLauncher":
				gun_name = "Grenade Launcher"
			if gun_name == "Pistol" or gun_name in Globals.available_guns:
				gun_node.material.set_shader_parameter("shade_color", Color(1, 1, 1, 0.1))
			else:
				gun_node.material.set_shader_parameter("shade_color", Color(0, 0, 0, 0.8))
	
func _on_inventory_button_pressed() -> void:

	if not is_inv_open:
		is_open_recipe_book = false
		recipe_book.close()
		cooking_ui.close()

		inventory.open()
		is_inv_open = true
	else:
		inventory.close()
		is_inv_open = false



func _on_recipe_book_button_pressed() -> void:
	if Globals.is_cooking:
		return
	if is_open_recipe_book:
		is_open_recipe_book = false
		cooking_ui.close()

		recipe_book.close()
	else:
		inventory.close()
		is_inv_open = false
		is_open_recipe_book = true
		recipe_book.open()


func _on_inventory_button_mouse_entered() -> void:
	Globals.is_hovering_on_ui = true


func _on_inventory_button_mouse_exited() -> void:
	Globals.is_hovering_on_ui = false


func _on_recipe_book_button_mouse_entered() -> void:
	Globals.is_hovering_on_ui = true


func _on_recipe_book_button_mouse_exited() -> void:
	Globals.is_hovering_on_ui = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		reset_outlines()
		Globals.active_gun = "Pistol"
		$Pistol.material.set_shader_parameter("outline_color", outline_color)
		$Pistol.material.set_shader_parameter("shade_color", shade_color)
		$ChangeWeaponSFX.play()
	elif Input.is_action_just_pressed("2") and "Shotgun" in Globals.available_guns:
		Globals.active_gun = "Shotgun"
		reset_outlines()
		$ChangeWeaponSFX.play()

		$Shotgun.material.set_shader_parameter("outline_color", outline_color)
		$Shotgun.material.set_shader_parameter("shade_color", shade_color)
	elif Input.is_action_just_pressed("3") and "AK47" in Globals.available_guns:
		Globals.active_gun = "AK47"
		reset_outlines()
		$ChangeWeaponSFX.play()

		$AK47.material.set_shader_parameter("outline_color", outline_color)
		$AK47.material.set_shader_parameter("shade_color", shade_color)
	elif Input.is_action_just_pressed("4") and "Grenade Launcher" in Globals.available_guns:
		Globals.active_gun = "Grenade Launcher"
		reset_outlines()
		$ChangeWeaponSFX.play()

		$GrenadeLauncher.material.set_shader_parameter("outline_color", outline_color)
		$GrenadeLauncher.material.set_shader_parameter("shade_color", shade_color)


func reset_outlines():
	var transparent = Color(1, 1, 1, 0)      
	var transparent_shade = Color(1, 1, 1, 0) 

	for gun in [$Pistol, $Shotgun, $AK47, $GrenadeLauncher]:

		if gun.material is ShaderMaterial:
			if not gun in Globals.available_guns:
				gun.material.set_shader_parameter("shade_color", Color(0, 0, 0, 0.8))
				gun.material.set_shader_parameter("outline_color", transparent)

			else:
				gun.material.set_shader_parameter("outline_color", transparent)
				gun.material.set_shader_parameter("shade_color", transparent_shade)
