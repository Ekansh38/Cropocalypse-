extends CanvasLayer

@export var player_inv: Inv

@onready var inventory = $ShoppingInvUI

func _ready():
	close()
	#Globals.connect("update_kitchen", Callable(self, "_update_kitchen"))
		
func open():
	if $TabBar.current_tab == 0:
		$BuyArea.visible = true
		inventory.visible = false
	else:
		inventory.visible = true
		$BuyArea.visible = false
		
	Globals.is_shopping = true
	$Panel.visible = true
	$TabBar.visible = true
	
func close():	
	$BuyArea.visible = false
	inventory.visible = false
	Globals.is_shopping = false

	$Panel.visible = false
	$TabBar.visible = false
	Globals.is_cooking = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		close()


func _on_tab_bar_tab_changed(tab: int) -> void:
	if tab == 1:
		$BuyArea.visible = false
		inventory.visible = true
	else:
		$BuyArea.visible = true
		inventory.visible = false


func _on_buy_shotgun_pressed() -> void:
	if Globals.money < 100:
		return
	
	if "Shotgun" in Globals.available_guns:
		return
		
	$BuySFX.play()

	Globals.money -= 100
	var temp = Globals.available_guns.duplicate()
	temp.append("Shotgun")
	Globals.available_guns = temp


func _on_buy_ak_47_pressed() -> void:
	if Globals.money < 150:
		return
	
	if "AK47" in Globals.available_guns:
		return
	
	$BuySFX.play()

	Globals.money -= 150
	var temp = Globals.available_guns.duplicate()
	temp.append("AK47")
	Globals.available_guns = temp


func _on_buy_grenade_pressed() -> void:
	if Globals.money < 15:
		return
	
	
	$BuySFX.play()
	Globals.money -= 15
	
	Globals.grenades += 1


func _on_buy_speed_boots_pressed() -> void:
	if Globals.money < 200:
		return
	
	if Globals.has_speed_boots:
		return
	
	$BuySFX.play()
	Globals.money -= 200
	
	Globals.has_speed_boots = true
