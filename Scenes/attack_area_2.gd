extends Area2D

var damage_cooldown := 2
var time_since_last_hit := 0.0

func _process(delta: float) -> void:
	if $"..".state == $"..".PlantState.HOSTILE:
		time_since_last_hit += delta

		if time_since_last_hit >= damage_cooldown:
			for area in get_overlapping_areas():
				if area.is_in_group("player_attack_area"):
					if area.has_method("take_damage"):
						# Face the player

						
						# Play animation and apply damage
						$"../Mature".stop()
						$"../Mature".play("attack")
						$"..".is_attack_playing = true
						time_since_last_hit = 0.0
						break  # only damage once per cooldown
