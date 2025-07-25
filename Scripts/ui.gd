extends CanvasLayer


func _ready() -> void:
	Globals.connect("update_stats", update_stats)
	$HealthBar.value = Globals.player_health

func update_stats():
	$HealthBar.value = Globals.player_health
