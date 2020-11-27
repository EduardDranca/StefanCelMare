extends OtomanAIState

var _attackTimer = 0
var _attackTime

func _init():
	._init()
	_currentState = ATTACK_STATE
	_attackTime = _rng.randf_range(0.5, 1)

func update(delta):
	_target.setTarget(_playerPosition)
	_attackTimer += delta
	if (_attackTimer >= _attackTime):
		_attackTimer -= _attackTime
		_target._weapon.attack()
	if ((_target.position - _playerPosition).length_squared() > _maxAttackRange * _maxAttackRange):
		return FOLLOW_STATE
	return _currentState
