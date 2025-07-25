extends Node

signal update_stats()

var is_hovering_on_ui = false

var player_health = 100:
	get:
		return player_health
	set(value):
		player_health = value
		update_stats.emit()

var player_hunger = 100:
	get:
		return player_hunger
	set(value):
		player_hunger = value
		update_stats.emit()

var player_thirst = 100:
	get:
		return player_thirst
	set(value):
		player_thirst = value
		update_stats.emit()

var player_money = 0
