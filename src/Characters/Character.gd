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

const moveAnimationDictionary = {
	Orientation.UP: "walk_up",
	Orientation.DOWN: "walk_down",
	Orientation.RIGHT: "walk_right",
	Orientation.LEFT: "walk_right"
}

const idleAnimationDictionary = {
	Orientation.UP: "idle_up",
	Orientation.DOWN: "idle_down",
	Orientation.RIGHT: "idle_right",
	Orientation.LEFT: "idle_right"
}

var _movementMask = 0
var _isMoving = false
var _orientation = Orientation.RIGHT
var _movementSpeed = Vector2()
var _target = Vector2()
var _deceleration = Vector2(2000, 2000)

func updateSpeed(delta):
	if (_movementMask & MovementMaskValues.LEFT == 0 and
		_movementMask & MovementMaskValues.RIGHT == 0 and
		_movementSpeed.x != 0):
		var newMovementSpeed = _movementSpeed
		var signX = sign(newMovementSpeed.x)
		newMovementSpeed.x -= signX * _deceleration.x * delta
		
		if (sign(newMovementSpeed.x) != signX):
			newMovementSpeed.x = 0
		
		setMovementSpeed(newMovementSpeed)
	if (_movementMask & MovementMaskValues.UP == 0 and
		_movementMask & MovementMaskValues.DOWN == 0 and
		_movementSpeed.y != 0):
		var newMovementSpeed = _movementSpeed
		var signY = sign(newMovementSpeed.y)
		newMovementSpeed.y -= signY * _deceleration.y * delta
		
		if (sign(newMovementSpeed.y) != signY):
			newMovementSpeed.y = 0
		
		setMovementSpeed(newMovementSpeed)

func updatePosition(delta):
	translate(_movementSpeed * delta)

func calculateOrientation():
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

func setMovementSpeed(movementSpeed):
	_movementSpeed = movementSpeed
	if (_movementSpeed.is_equal_approx(Vector2(0, 0))):
		_movementSpeed = Vector2(0, 0)
		_isMoving = false
	else:
		_isMoving = true

func setTarget(target):
	_target = target - get_global_transform_with_canvas().get_origin()
	calculateOrientation()

func updateAnimation():
	if (_orientation == Orientation.LEFT):
		get_node("Sprite").flip_h = true
	elif (_orientation == Orientation.RIGHT):
		get_node("Sprite").flip_h = false
	if (_isMoving):
		get_node("AnimationPlayer").play(moveAnimationDictionary.get(_orientation))
	else:
		get_node("AnimationPlayer").play(idleAnimationDictionary.get(_orientation))

func _process(delta):
	updatePosition(delta)
	updateSpeed(delta)
