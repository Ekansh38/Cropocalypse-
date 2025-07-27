extends Node

signal update_stats()
signal update_active_gun()
signal game_over()


var _active_gun = "Pistol"
var active_gun: String:
	get:
		return _active_gun
	set(value):
		_active_gun = value
		update_active_gun.emit()


signal update_kitchen()
var is_recipe_book_open = false
var is_hovering_on_ui = false

var _available_guns = ["Pistol"]
var available_guns:
	get:
		return _available_guns
	set(value):
		_available_guns = value
		update_stats.emit()

var _kitchen_slots: Array[InvItem] = []
var _money = 0
var money: int:
	get:
		return _money
	set(value):
		_money = value
		update_stats.emit()
		
		
		
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
		game_over.emit()

	update_stats.emit()
var 	is_shopping = false

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

var _has_speed_boots = false
var has_speed_boots:
	get:
		return _has_speed_boots
	set(value):
		_has_speed_boots = value
		update_active_gun.emit()

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
			game_over.emit()
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




func reset():
	player_health = 100
	player_hunger = 100
	player_thirst = 100
	_grenades = 3
	_kitchen_slots.clear()
	is_cooking = false
	is_recipe_book_open = false
	is_hovering_on_ui = false
	is_shopping = false
	_money = 0
	_available_guns = ["Pistol"]
	active_gun = "Pistol"
	var inventory = load("res://Inventory/player_inventory.tres")
	if inventory:
		inventory.slots.clear()

	update_stats.emit()
	update_kitchen.emit()
