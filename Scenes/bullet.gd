extends Area2D

@export var speed: float = 1500.0
@export var lifespan: float = 2.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(lifespan).timeout
	queue_free()

func _process(delta: float) -> void:
	position += direction * speed * delta

func setup(dir: Vector2) -> void:
	direction = dir.normalized()
	rotation = direction.angle()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		return
	if "take_damage" in body:
		var damage
		if Globals.active_gun == "Shotgun":
			damage = 100
		elif Globals.active_gun == "Pistol":
			damage = 25
		elif Globals.active_gun == "AK47":
			damage = 20
			
		var knockback_force = direction * 700  # tweak as needed
		body.take_damage(knockback_force, damage)
	queue_free()  
