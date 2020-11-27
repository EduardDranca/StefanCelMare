extends Node2D
var OAIS = preload("res://src/Characters/Otoman/AI/OtomanAIState.gd").new()
var _target
var _dict = OAIS.AIStateDictionary
var _currentState = _dict.get(OAIS.EXPLORE_STATE).new()
var _lastPlayerPosition

func setTarget(target):
	_target = target
	_currentState.setTarget(_target)

func updatePlayerPosition(playerPosition):
	_lastPlayerPosition = playerPosition
	_currentState.updatePlayerPosition(playerPosition);

func updateAI(delta):
	var nextState = _currentState.update(delta)
	if (nextState != _currentState.getState()):
		_currentState = _dict.get(nextState).new()
		_currentState.updatePlayerPosition(_lastPlayerPosition)
		_currentState.setTarget(_target)
