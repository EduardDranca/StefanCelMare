extends Node2D

const ExploreAIState = preload("res://src/Characters/Otoman/AI/ExploreAIState.gd")

var _target
var _currentState = ExploreAIState.new()

func setTarget(target):
	_target = target
	_currentState.setTarget(_target)

func updatePlayerPosition(playerPosition):
	_currentState.updatePlayerPosition(playerPosition);

func updateAI(delta):
	var nextState = _currentState.update(delta)
	if (nextState != null):
		_currentState = nextState.new()
		_currentState.setTarget(_target)
