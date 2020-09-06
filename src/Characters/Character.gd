extends KinematicBody2D

enum Orientation {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum MovementMaskValues {
	NO_MOVEMENT = 0,
	UP = 1,
	DOWN = 2,
	LEFT = 4,
	RIGHT = 8
}

var _movementMask = 0
var _isMoving = false
var _orientation = Orientation.RIGHT
var _movementSpeed = Vector2()
var _target = Vector2()
var _deceleration = Vector2(2000, 2000)

func _ready():
	pass
func _updateSpeed(delta):
	if (_movementMask & MovementMaskValues.LEFT == 0 and
		_movementMask & MovementMaskValues.RIGHT == 0 and
		_movementSpeed.x != 0):
		var newMovementSpeed = _movementSpeed
		var signX = sign(newMovementSpeed.x)
		newMovementSpeed.x -= signX * _deceleration.x
		if (sign(newMovementSpeed.x) != signX):
			newMovementSpeed.x = 0
		_setMovementSpeed(newMovementSpeed)
	if (_movementMask & MovementMaskValues.UP == 0 and
		_movementMask & MovementMaskValues.DOWN == 0 and
		_movementSpeed.y != 0):
		var newMovementSpeed = _movementSpeed
		var signY = sign(newMovementSpeed.y)
		newMovementSpeed.y -= signY * _deceleration.y
		if (sign(newMovementSpeed.y) != signY):
			newMovementSpeed.y = 0
		_setMovementSpeed(newMovementSpeed)
		

func _updatePosition(delta):
	translate(_movementSpeed * delta)

func _calculateOrientation():
	if (abs(_target.x) < abs(_target.y)):
		if _target.y < 0:
			_orientation = Orientation.UP
		else:
			_orientation = Orientation.DOWN
	else:
		if _target.x < 0:
			_orientation = Orientation.LEFT
		else:
			_orientation = Orientation.RIGHT

func _setMovementSpeed(movementSpeed):
	_movementSpeed = movementSpeed
	if (_movementSpeed.is_equal_approx(Vector2(0, 0))):
		_movementSpeed = Vector2(0, 0)
		_isMoving = false
	else:
		_isMoving = true

func _setTarget(target):
	_target = target
	_calculateOrientation()

func _process(delta):
	_updatePosition(delta)
	_updateSpeed(delta)
