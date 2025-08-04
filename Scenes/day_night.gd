extends CanvasModulate

const DAY_COLOR = Color("#fffff1")
const NIGHT_COLOR = Color("#465b7e")

const DAY_SPEED = 0.05
const NIGHT_SPEED = 0.3
const HOLD_DURATION = 3.0

var time: float = -PI / 2 
var is_night = false
var hold_timer = 0.0

@onready var lanterns_node = $"../Lanterns"

func _process(delta: float) -> void:
	var raw_blend = (sin(time) + 1.0) / 2.0
	var bias_blend = pow(raw_blend, 0.7)
	self.color = DAY_COLOR.lerp(NIGHT_COLOR, bias_blend)

	# Hold at full day
	if raw_blend >= 0.99 and hold_timer < HOLD_DURATION:
		hold_timer += delta
	else:
		var speed
		if (raw_blend < 0.8):
			speed = DAY_SPEED
		else:
			speed = NIGHT_SPEED
		time += delta * speed
		hold_timer = 0.0

	# Toggle lanterns
	if bias_blend > 0.8 and not is_night:
		is_night = true
		turn_on_lanterns()
	elif bias_blend < 0.2 and is_night:
		is_night = false
		turn_off_lanterns()

func turn_on_lanterns():
	for lantern in lanterns_node.get_children():
		lantern.light_on()

func turn_off_lanterns():
	for lantern in lanterns_node.get_children():
		lantern.light_off()
