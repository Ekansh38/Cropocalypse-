extends Node

signal update_stats()

var player_health = 100:
	get:
		return player_health
	set(value):
		player_health = value
		update_stats.emit()

var player_hunger = 100
var player_thirst = 100
var player_money = 0
