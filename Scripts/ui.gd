extends CanvasLayer

@export var inventory: Control
@export var recipe_book: CanvasLayer

var is_open_recipe_book = false
var is_inv_open = false
func _ready() -> void:
	Globals.connect("update_stats", update_stats)
	$HealthBar.value = Globals.player_health

func update_stats():
	$HealthBar.value = Globals.player_health
	$ThirstBar.value = Globals.player_thirst
	$HungerBar.value = Globals.player_hunger


func _on_inventory_button_pressed() -> void:

	if not is_inv_open:
		is_open_recipe_book = false
		recipe_book.close()
		inventory.open()
		is_inv_open = true
	else:
		inventory.close()
		is_inv_open = false



func _on_recipe_book_button_pressed() -> void:
	if is_open_recipe_book:
		is_open_recipe_book = false
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
