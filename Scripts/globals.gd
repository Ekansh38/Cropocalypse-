extends Node

signal update_stats()

var is_hovering_on_ui = false


var recipes = {
	"Mango Sticky Rice": {
		"ingredients": ["Mango", "Rice"],
		"unlocked": true
	},
	"Ordinary Fried Rice": {
		"ingredients": ["Rice", "Onion"],
		"unlocked": true
	},
	"Spicy Bok Choy Salad": {
		"ingredients": ["Bok Choy", "Chili"],
		"unlocked": false
	},
	"Spicy Fried Rice": {
		"ingredients": ["Rice", "Onion", "Chili"],
		"unlocked": false
	},
	"Yangzhou Fried Rice": {
		"ingredients": ["Rice", "Onion", "Bok Choy"],
		"unlocked": false
	},
	"Chili Crunch Oil": {
		"ingredients": ["Onion", "Chili"],
		"unlocked": false
	},
	"Mango Mochi": {
		"ingredients": ["Mango", "Rice", "Rice"],
		"unlocked": false
	},
	"Chili Mango Salad": {
		"ingredients": ["Mango", "Chili"],
		"unlocked": false
	},
	"Chili Garlic Noodles": {
		"ingredients": ["Chili", "Onion", "Bok Choy"],
		"unlocked": false
	}
}

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
