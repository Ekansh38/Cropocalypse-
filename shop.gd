extends StaticBody2D

var player_in_area = null
var is_ui_open = false

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = body
		player_in_area.change_control_label("Press E to Open Shop")

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = null
		body.change_control_label("")
		
		if is_ui_open == true:
			is_ui_open = false
			$"../ShopUI".close()
			get_tree().paused = false



func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("interact"):
			if not is_ui_open:
				$"../ShopUI".open()

				$"../RecipeBook".close()
				$"../CanvasLayer/InvUI".close()
				is_ui_open = true
				Globals.is_cooking = true
			else:
				is_ui_open = false
				$"../ShopUI".close()


				
