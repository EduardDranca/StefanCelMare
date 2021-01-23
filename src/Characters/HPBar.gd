extends Sprite

var _ratio = 1.0;

func _ready():
	visible = false
	get_material().set_shader_param("ratio", _ratio)
	$DisplayTimer.connect("timeout", self, "stopDisplaying")

func display(permanently = false):
	visible = true
	$DisplayTimer.start()

func setRatio(value):
	value = clamp(value, 0, 1)
	_ratio = value
	get_material().set_shader_param("ratio", _ratio)

func stopDisplaying():
	visible = false
