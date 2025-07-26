extends Area2D

@export var mango: InvItem

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		body.add_item(mango)
		queue_free()
