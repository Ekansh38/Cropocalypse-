extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
var is_hovering = false
var hide_timer := Timer.new()
@onready var hover_area = $HoverArea
var current_slot: InvSlot
@export var inv: Inv


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
		details = "+ $" + str(slot.item.sell_price)
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
		
		Globals.money += current_slot.item.sell_price
		if current_slot.item.sell_price > 20:
			$Expensive.play()
		else:
			$Cheap.play()
		current_slot.item = null
		item_visual.visible = false
		$HoverDisplay.visible = false
		$HoverDisplay/VBoxContainer/DetailsLabel.text = ""
		inv.remove(current_slot.item)


func _on_eat_button_pressed() -> void:
	if current_slot and current_slot.item:
		Globals.player_hunger += current_slot.item.added_hunger
		Globals.player_thirst += current_slot.item.added_thirst
		current_slot.item = null
		item_visual.visible = false
		$HoverDisplay.visible = false
		$HoverDisplay/VBoxContainer/DetailsLabel.text = ""
		inv.remove(current_slot.item)
