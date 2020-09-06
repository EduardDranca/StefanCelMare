extends "res://src/Characters/Character.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	var newMovementSpeed = _movementSpeed;
	if (event.is_action_pressed("move_up")):
		_movementMask |= MovementMaskValues.UP
		newMovementSpeed.y = -250
	if (event.is_action_pressed("move_down")):
		_movementMask |= MovementMaskValues.DOWN
		newMovementSpeed.y = 250
	if (event.is_action_pressed("move_left")):
		_movementMask |= MovementMaskValues.LEFT
		newMovementSpeed.x = -250
	if (event.is_action_pressed("move_right")):
		_movementMask |= MovementMaskValues.RIGHT
		newMovementSpeed.x = 250
	if (event.is_action_released("move_up")):
		_movementMask &= ~MovementMaskValues.UP
	if (event.is_action_released("move_down")):
		_movementMask &= ~MovementMaskValues.DOWN
	if (event.is_action_released("move_left")):
		_movementMask &= ~MovementMaskValues.LEFT
	if (event.is_action_released("move_right")):
		_movementMask &= ~MovementMaskValues.RIGHT
	._setMovementSpeed(newMovementSpeed)

func _process(delta):
	var target = get_global_mouse_position() - position
	
	._process(delta)
	._setTarget(target)
