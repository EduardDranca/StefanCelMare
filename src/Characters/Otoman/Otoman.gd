extends "res://src/Characters/Character.gd"

var _weaponDictionary = WeaponSceneDictionary.weaponSceneDictionary
var _spearScene = _weaponDictionary.get("spear")
var _weapon = _spearScene.instance()
var _playerPosition = Vector2(200, 200)
var _playerPositionIsSet = false
var _playerInAttackRange = false
var _movingTo = false
var _destination = Vector2(0, 0)

const MAX_SPEED = 200
const MAX_DISTANCE = 500

onready var AI = $OtomanAISystem

signal moveToFinished(position)

func _ready():
	add_child(_weapon)
	AI.setTarget(self)
	_weapon.connect("attacked", self, "attack")
	_weapon.get_node("HitArea").connect("body_entered", self, "checkBodyInAttackRange")
	_weapon.get_node("HitArea").connect("body_exited", self, "checkBodyInAttackRange")

func attack(hitBox, damage):
	for overlappingBody in hitBox.get_overlapping_bodies():
		if (overlappingBody.is_in_group("player")):
			overlappingBody.hit(damage)

func checkBodyInAttackRange(body):
	if (body.is_in_group("player")):
		_playerInAttackRange = !_playerInAttackRange

func updatePlayerPosition(playerPosition):
	_playerPosition = playerPosition
	setTarget(_playerPosition)
	AI.updatePlayerPosition(_playerPosition)

func moveTo(moveToPosition, speed):
	_movingTo = true
	_destination = moveToPosition
	speed = clamp(speed, 0, MAX_SPEED)
	setMovementSpeed((moveToPosition - position).normalized() * speed)
	updateMovementMask(_movementSpeed)

func setTarget(target):
	.setTarget(target)
	_weapon.setTarget(_target)

func checkMoveTo():
	if ((_destination - position).length_squared() <= 40 and _movingTo):
		_movingTo = false
		setMovementSpeed(Vector2(0, 0))
		updateMovementMask(_movementSpeed)
		emit_signal("moveToFinished", position)

func _process(delta):
	._process(delta)
	checkMoveTo()
	AI.updateAI(delta)
