extends Node

signal update_stats()

signal update_kitchen()
var is_recipe_book_open = false
var is_hovering_on_ui = false

var _kitchen_slots: Array[InvItem] = []

var damage_timer = null
func _ready():
	damage_timer = Timer.new()
	damage_timer.wait_time = 0.5
	damage_timer.autostart = true
	damage_timer.one_shot = false
	damage_timer.timeout.connect(_on_damage_tick)
	add_child(damage_timer)

func _on_damage_tick():
	var took_damage = false

	if player_hunger <= 0:
		player_health -= 1.5
		took_damage = true

	if player_thirst <= 0:
		player_health -= 1.5
		took_damage = true

	if not took_damage and player_hunger > 75 and player_thirst > 75:
		if player_health < 100:
			player_health += 0.5

	if player_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

	update_stats.emit()


var _grenades: int = 3
var grenades: int:
	get:
		return _grenades
	set(value):
		_grenades = value
		update_stats.emit()

var kitchen_slots: Array[InvItem]:
	get: return _kitchen_slots
	set(value):
		_kitchen_slots = value
		update_kitchen.emit()
		

var is_cooking = false


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
		"unlocked": true
	},
	"Spicy Fried Rice": {
		"ingredients": ["Rice", "Onion", "Chili"],
		"unlocked": true
	},
	"Yangzhou Fried Rice": {
		"ingredients": ["Rice", "Onion", "Bok Choy"],
		"unlocked": true
	},
	"Chili Crunch Oil": {
		"ingredients": ["Onion", "Chili"],
		"unlocked": true
	},
	"Mango Mochi": {
		"ingredients": ["Mango", "Rice", "Rice"],
		"unlocked": true
	},
	"Chili Mango Salad": {
		"ingredients": ["Mango", "Chili"],
		"unlocked": true
	},
	"Chili Garlic Noodles": {
		"ingredients": ["Chili", "Onion", "Bok Choy"],
		"unlocked": true
	}
}

var player_health = 100:
	get:
		return player_health
	set(value):
		player_health = value
		if player_health <= 0:
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
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
