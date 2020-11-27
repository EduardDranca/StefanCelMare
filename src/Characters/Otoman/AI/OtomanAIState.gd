class_name OtomanAIState

enum {EXPLORE_STATE, FOLLOW_STATE, ATTACK_STATE}

var AIStateDictionary = {
	EXPLORE_STATE: load("res://src/Characters/Otoman/AI/ExploreAIState.gd"),
	FOLLOW_STATE: load("res://src/Characters/Otoman/AI/FollowAIState.gd"),
	ATTACK_STATE: load("res://src/Characters/Otoman/AI/AttackAIState.gd")
}

const _maxAttackRange = 100
const _minAttackRange = 50
const _visibleRange = 400
var _playerPosition = Vector2(0, 0)
var _playerPositionInitialized = false
var _currentState
var _target
var _rng = RandomNumberGenerator.new()

func _init():
	_rng.seed = OS.get_unix_time()

func getState():
	return _currentState

func setTarget(target):
	_target = target

func updatePlayerPosition(playerPosition):
	_playerPositionInitialized = true
	_playerPosition = playerPosition

func update(delta):
	pass
