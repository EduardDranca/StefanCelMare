extends "res://src/Characters/Character.gd"

var _weaponDictionary = WeaponPathDictionary.weaponScenesDictionary
var _spearScene = _weaponDictionary.get("spear")
var _weapon = _spearScene.instance()
var _playerPosition = Vector2(0, 0)
var _playerPositionIsSet = false
var _playerInAttackRange = false

const MAX_SPEED = 200
const MAX_DISTANCE = 500


func _ready():
	add_child(_weapon)
	_weapon.connect("attacked", self, "attack")
	_weapon.get_node("HitArea").connect("body_entered", self, "checkBodyInAttackRange")
	_weapon.get_node("HitArea").connect("body_exited", self, "checkBodyInAttackRange")

func isInRange(position):
	return (self.position - position).length_squared() <= MAX_DISTANCE * MAX_DISTANCE

func attack(hitBox, damage):
	for overlappingBody in hitBox.get_overlapping_bodies():
		if (overlappingBody.is_in_group("player")):
			overlappingBody.hit(damage)

func checkBodyInAttackRange(body):
	if (body.is_in_group("player")):
		_playerInAttackRange = !_playerInAttackRange

func updatePlayerPosition(position):
	if (isInRange(position)):
		_playerPositionIsSet = true
		_playerPosition = position
	else:
		clearMovementMask()

func moveTo(position):
	setMovementSpeed((position - self.position).normalized() * MAX_SPEED)
	updateMovementMask(_movementSpeed)

func setTarget(target):
	.setTarget(target)
	_weapon.setTarget(target)

func _process(delta):
	._process(delta)
	setTarget(_playerPosition)
	if (_playerPositionIsSet):
		moveTo(_playerPosition)
