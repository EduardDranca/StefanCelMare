extends "res://src/Characters/Character.gd"


func _process(delta):
	var target = get_global_mouse_position() - position
	
	._process(delta)
	setTarget(target)
	updateAnimation()
