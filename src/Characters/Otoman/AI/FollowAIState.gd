extends OtomanAIState

class_name FollowAIState

var _speed = 150
var _attackRange

func _init():
	._init()
	_currentState = FOLLOW_STATE
	_attackRange = _rng.randf_range(_minAttackRange, _maxAttackRange)

func update(delta):
	var deltaPosition = (_target.position - _playerPosition).normalized() * _attackRange
	_target.setTarget(_playerPosition)
	_target.moveTo(_playerPosition + deltaPosition, _speed)
	if ((_target.position - _playerPosition).length_squared() > _visibleRange * _visibleRange):
		return EXPLORE_STATE
	if ((_target.position - _playerPosition).length_squared() <= _attackRange * _attackRange):
		return ATTACK_STATE
	return _currentState
