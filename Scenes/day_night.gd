extends CanvasModulate

const DAY_COLOR = Color("#fffff1")
const NIGHT_COLOR = Color("#465b7e")
const TIME_SCALE = 0.1

var time: float = -PI / 2 

func _process(delta: float) -> void:
	time += delta * TIME_SCALE

	var raw_blend = (sin(time) + 1.0) / 2.0
	var bias_blend = pow(raw_blend, 0.7)

	self.color = DAY_COLOR.lerp(NIGHT_COLOR, bias_blend)
