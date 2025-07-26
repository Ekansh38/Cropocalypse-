extends CanvasLayer

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
	
	$CookingInvUI.close()
	$OtherThings.visible = false
	
func _update_kitchen():
	var slot_nodes = [
$OtherThings/KitchenInvUISlot,
$OtherThings/KitchenInvUISlot2,
$OtherThings/KitchenInvUISlot3
	]

	for i in range(slot_nodes.size()):
		var slot_node = slot_nodes[i]
		print(i)
		print(Globals.kitchen_slots.size())
		if i < Globals.kitchen_slots.size():
			var item = Globals.kitchen_slots[i]
			slot_node.visible = true
			var new_slot := InvSlot.new()
			new_slot.item = item
			slot_node.update(new_slot)
