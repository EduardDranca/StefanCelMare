extends "res://src/Characters/Character.gd"

var _weaponDictionary = WeaponSceneDictionary.weaponSceneDictionary
var _swordScene = _weaponDictionary.get("sword")
var _weapon = _swordScene.instance()
const MAX_SPEED = 200

signal moved(position)

const enemyGroup = "enemies"

func _ready():
	add_child(_weapon)
	_weapon.setEnemyGroup(enemyGroup)
	_weapon.connect("requestSound", self, "playSound")

func setTarget(target):
	.setTarget(target)
	_weapon.setTarget(_target)

func _input(event):
	var newMovementSpeed = _movementSpeed;
	if (event.is_action_pressed("move_up")):
		newMovementSpeed.y = -MAX_SPEED
		_movementMask |= MovementMaskValues.UP
	if (event.is_action_pressed("move_down")):
		newMovementSpeed.y = MAX_SPEED
		_movementMask |= MovementMaskValues.DOWN
	if (event.is_action_pressed("move_left")):
		newMovementSpeed.x = -MAX_SPEED
		_movementMask |= MovementMaskValues.LEFT
	if (event.is_action_pressed("move_right")):
		newMovementSpeed.x = MAX_SPEED
		_movementMask |= MovementMaskValues.RIGHT
		
	if (event.is_action_pressed("attack")):
		_weapon.attack()
		
	if (event.is_action_released("move_up")):
		_movementMask &= ~MovementMaskValues.UP
	if (event.is_action_released("move_down")):
		_movementMask &= ~MovementMaskValues.DOWN
	if (event.is_action_released("move_left")):
		_movementMask &= ~MovementMaskValues.LEFT
	if (event.is_action_released("move_right")):
		_movementMask &= ~MovementMaskValues.RIGHT
		
	.setMovementSpeed(newMovementSpeed)

	

func _process(delta):
	var target = get_global_mouse_position()
	var oldPosition = position
	._process(delta)
	if (position != oldPosition):
		emit_signal("moved", position)
	setTarget(target)
