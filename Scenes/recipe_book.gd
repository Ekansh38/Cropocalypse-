extends CanvasLayer

var is_open = false

func _ready():
	is_open = false
	$VBoxContainer.visible = false
	$ColorRect.visible = false
	get_tree().paused = false


	for recipe_name in Globals.recipes.keys():
		# Convert the recipe name to a matching node name (remove spaces)
		var node_name = recipe_name.replace(" ", "")
		var recipe_ui = $VBoxContainer.get_node_or_null(node_name)

		if recipe_ui:
			var unlocked = Globals.recipes[recipe_name]["unlocked"]
			var unlocked_rect = recipe_ui.get_node("Unlocked")
			print(unlocked)
			if not unlocked:
				recipe_ui.modulate = Color("#000000")
	
func close():
	Globals.is_recipe_book_open = false

	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	is_open = false
	$VBoxContainer.visible = false
	$ColorRect.visible = false
	get_tree().paused = false


func open():
	Globals.is_recipe_book_open = true
	is_open = true
	$VBoxContainer.visible = true
	$ColorRect.visible = true
	get_tree().paused = true
	$AnimationPlayer.play("open")
