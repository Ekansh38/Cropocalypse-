extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
var is_hovering = false
var hide_timer := Timer.new()
@onready var hover_area = $HoverArea
var current_slot: InvSlot
@export var inv: Inv

@export var player_inv: Inv
signal entered

var details = ""

func _ready():
	item_visual.visible = false
	$HoverDisplay.visible = false
	
	hover_area.modulate.a = 0
	hide_timer.wait_time = 2
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_hide_hover_display)
	add_child(hide_timer)

func update(slot: InvSlot):
	current_slot = slot  

	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		details = slot.item.details
		$HoverDisplay/VBoxContainer/DetailsLabel.text = details

		
func _on_hover_area_mouse_entered():
	entered.emit()
	is_hovering = true
	if item_visual.visible == true:
		$HoverDisplay.visible = true
		hide_timer.stop()
	
	$CenterContainer/Panel/ItemDisplay.scale = Vector2(0.13,0.13)

func _on_hover_area_mouse_exited():
	is_hovering = false
	hide_timer.start()
	$CenterContainer/Panel/ItemDisplay.scale = Vector2(0.1,0.1)


func hide_hover():
	$HoverDisplay.visible = false
	
func _hide_hover_display():
	if not is_hovering:
		$HoverDisplay.visible = false


func _on_drop_button_pressed() -> void:
	if current_slot and current_slot.item:
		var item_to_remove = current_slot.item 

		var new_slots = Globals.kitchen_slots.duplicate()
		new_slots.erase(item_to_remove)
		Globals.kitchen_slots = new_slots 

		inv.remove(item_to_remove)
		$"../Button".disabled = true
		$"../.."._update_kitchen()
		player_inv.insert(item_to_remove)

		# Clear visuals
		current_slot.item = null
		item_visual.visible = false
		$HoverDisplay.visible = false
		$HoverDisplay/VBoxContainer/DetailsLabel.text = ""
		
		
func _on_eat_button_pressed() -> void:
	if current_slot and current_slot.item:
		Globals.player_hunger += current_slot.item.added_hunger
		Globals.player_thirst += current_slot.item.added_thirst
		current_slot.item = null
		item_visual.visible = false
		$HoverDisplay.visible = false
		$HoverDisplay/VBoxContainer/DetailsLabel.text = ""
		inv.remove(current_slot.item)
