extends Resource
class_name Inv

@export var slots: Array[InvSlot]

signal update

func insert(item: InvItem):
	
	var empty_slots = slots.filter(func(slot): return slot.item == null)
	print(empty_slots)
	if !empty_slots.is_empty():
		empty_slots[0].item = item
	
	update.emit()

func remove(item: InvItem) -> void:
	for slot in slots:
		if slot.item == item:
			slot.item = null
			update.emit()
			return
