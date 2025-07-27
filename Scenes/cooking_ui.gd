extends CanvasLayer

@export var player_inv: Inv

func _ready():
	$CookingInvUI.close()
	$OtherThings.visible = false
	$OtherThings/Button.disabled = true
	Globals.connect("update_kitchen", Callable(self, "_update_kitchen"))
		
func open():

	$CookingInvUI.open()
	$OtherThings.visible = true

#func _process(delta: float) -> void:
	#_update_kitchen()

	
func close():	
	Globals.is_cooking = false

	$CookingInvUI.close()
	$OtherThings.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		close()

func _update_kitchen():
	var slot_nodes = [
		$OtherThings/KitchenInvUISlot,
		$OtherThings/KitchenInvUISlot2,
		$OtherThings/KitchenInvUISlot3
	]

	# === Update slot visuals ===
	for i in range(slot_nodes.size()):
		var slot_node = slot_nodes[i]
		if i < Globals.kitchen_slots.size():
			var item = Globals.kitchen_slots[i]
			slot_node.visible = true
			var new_slot := InvSlot.new()
			new_slot.item = item
			slot_node.update(new_slot)

	var current_ingredients: Array[String] = []
	for item in Globals.kitchen_slots:
		current_ingredients.append(item.name)  # assuming item has a .name

	current_ingredients.sort()  # Sort for comparison

	for recipe_name in Globals.recipes.keys():
		var recipe = Globals.recipes[recipe_name]
		var recipe_ingredients = recipe.ingredients.duplicate()
		recipe_ingredients.sort()
		print(recipe)
		print(recipe_ingredients)
		if recipe_ingredients == current_ingredients:
			print("Matched recipe: ", recipe_name)
			$OtherThings/Button.disabled = false
			break


func _on_button_pressed() -> void:
	if player_inv.is_full():
		return
	var dish
	var current_ingredients: Array[String] = []
	for item in Globals.kitchen_slots:
		current_ingredients.append(item.name) 

	current_ingredients.sort()  # Sort for comparison

	for recipe_name in Globals.recipes.keys():
		var recipe = Globals.recipes[recipe_name]
		var recipe_ingredients = recipe.ingredients.duplicate()
		recipe_ingredients.sort()
		if recipe_ingredients == current_ingredients:
			dish = recipe_name
	
	if not dish:
		return
			
	Globals.kitchen_slots = []
	
	if dish == "Mango Sticky Rice":
		Globals.recipes["Mango Sticky Rice"]["unlocked"] = true
		var mango_sticky_rice: InvItem = preload("res://Inventory/items/mangostickyrice.tres")
		player_inv.insert(mango_sticky_rice)
	elif dish == "Ordinary Fried Rice":
		Globals.recipes["Ordinary Fried Rice"]["unlocked"] = true
		var ordinary_fried_rice: InvItem = preload("res://Inventory/items/ordinaryfriedrice.tres")
		player_inv.insert(ordinary_fried_rice)
	elif dish == "Spicy Bok Choy Salad":
		Globals.recipes["Spicy Bok Choy Salad"]["unlocked"] = true
		var spicy_bok_choy_salad: InvItem = preload("res://Inventory/items/spicybokchoisalad.tres")
		player_inv.insert(spicy_bok_choy_salad)
	
	elif dish == "Spicy Fried Rice":
		Globals.recipes["Spicy Fried Rice"]["unlocked"] = true
		var spicy_fried_rice: InvItem = preload("res://Inventory/items/spicyfriendrice.tres")
		player_inv.insert(spicy_fried_rice)
		
	elif dish == "Yangzhou Fried Rice":
		Globals.recipes["Yangzhou Fried Rice"]["unlocked"] = true
		var yangzhou_fried_rice: InvItem = preload("res://Inventory/items/yangzhoufriedrice.tres")
		player_inv.insert(yangzhou_fried_rice)

	elif dish == "Chili Crunch Oil":
		Globals.recipes["Chili Crunch Oil"]["unlocked"] = true
		var chili_crunch_oil: InvItem = preload("res://Inventory/items/chilicrunchoil.tres")
		player_inv.insert(chili_crunch_oil)
	elif dish == "Mango Mochi":
		Globals.recipes["Mango Mochi"]["unlocked"] = true
		var mango_mochi: InvItem = preload("res://Inventory/items/mangomochi.tres")
		player_inv.insert(mango_mochi)
	elif dish == "Chili Mango Salad":
		Globals.recipes["Chili Mango Salad"]["unlocked"] = true
		var chili_mango_salad: InvItem = preload("res://Inventory/items/chili_mango_salad.tres")
		player_inv.insert(chili_mango_salad)
	elif dish == "Chili Garlic Noodles":
		Globals.recipes["Chili Garlic Noodles"]["unlocked"] = true
		var chili_garlic_noodles: InvItem = preload("res://Inventory/items/chili_garlic_noodles.tres")
		player_inv.insert(chili_garlic_noodles)
	
	$AudioStreamPlayer.play()
	$OtherThings/KitchenInvUISlot.remove()
	$OtherThings/KitchenInvUISlot2.remove()
	$OtherThings/KitchenInvUISlot3.remove()
	$OtherThings/Button.disabled = true
