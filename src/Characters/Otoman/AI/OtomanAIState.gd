class_name OtomanAIState

const _attackRange = 60
const _visibleRange = 300
var _playerPosition = Vector2(0, 0)
var _playerPositionInitialized = false
var _target

func setTarget(target):
	_target = target

func updatePlayerPosition(playerPosition):
	_playerPositionInitialized = true
	_playerPosition = playerPosition

func update(delta):
	pass
