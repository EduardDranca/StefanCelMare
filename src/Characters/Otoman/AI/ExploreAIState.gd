extends OtomanAIState

class_name ExploreAIState

const SIN_45 = 0.70710678118
const MAX_MOVE_DISTANCE = 400 * SIN_45
const MAX_IDLE_TIME = 10
const MIN_IDLE_TIME = 5
var _destination = Vector2(0, 0)
var _idle = false
var _isMoving = false
var _idleTimer = 0
var _idleTime = 0
var _speed = 150
var _nextState = self

func _init():
	._init()
	_currentState = EXPLORE_STATE
	_idleTime = _rng.randf_range(MIN_IDLE_TIME, MAX_IDLE_TIME)

func setTarget(target):
	.setTarget(target)
	target.connect("moveToFinished", self, "onMoveToFinished")

func moveTargetToRandom():
		_isMoving = true
		var xCoeff = _rng.randf_range(-1, 1)
		var yCoeff = _rng.randf_range(-1, 1)
		var moveDelta = Vector2(xCoeff * MAX_MOVE_DISTANCE, yCoeff * MAX_MOVE_DISTANCE);
		_destination = _target.position + moveDelta
		_target.setTarget(_destination)
		_target.moveTo(_destination, _speed)

func updateIdleTimer(delta):
	_idleTimer += delta
	if (_idleTimer >= _idleTime):
		_idleTimer = 0
		_idle = false

func update(delta):
	if (_playerPositionInitialized and (_target.position - _playerPosition).length_squared() <= _visibleRange * _visibleRange):
		return FOLLOW_STATE
	if (!_idle and !_isMoving):
		moveTargetToRandom()
	else:
		updateIdleTimer(delta)
	return _currentState

func onMoveToFinished(position):
	_isMoving = false
	_idle = true
