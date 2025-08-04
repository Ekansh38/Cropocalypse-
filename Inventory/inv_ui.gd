extends Control


var is_open = false

@onready var inv: Inv = preload("res://Inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func _process(delta):
	if Input.is_action_just_pressed("inventory") and not Globals.is_cooking and not Globals.is_recipe_book_open:
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false


func _on_inv_ui_slot_entered() -> void:
	$NinePatchRect/GridContainer/InvUISlot2.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot3.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot4.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot5.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot6.hide_hover()


func _on_inv_ui_slot_2_entered() -> void:
	$NinePatchRect/GridContainer/InvUISlot.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot3.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot4.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot5.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot6.hide_hover()


func _on_inv_ui_slot_3_entered() -> void:
	$NinePatchRect/GridContainer/InvUISlot.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot2.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot4.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot5.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot6.hide_hover()


func _on_inv_ui_slot_4_entered() -> void:
	$NinePatchRect/GridContainer/InvUISlot.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot2.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot3.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot5.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot6.hide_hover()


func _on_inv_ui_slot_5_entered() -> void:
	$NinePatchRect/GridContainer/InvUISlot.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot2.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot3.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot4.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot6.hide_hover()


func _on_inv_ui_slot_6_entered() -> void:
	$NinePatchRect/GridContainer/InvUISlot.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot2.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot3.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot4.hide_hover()
	$NinePatchRect/GridContainer/InvUISlot5.hide_hover()
