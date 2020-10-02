extends "res://src/Characters/Character.gd"

var _weaponDictionary = WeaponPathDictionary.weaponScenesDictionary
var _swordPackedScene = _weaponDictionary.get("sword")
var _spearPackedScene = _weaponDictionary.get("spear")
var _weapon = _spearPackedScene.instance()

func _ready():
	_weapon.setDamage(100)
	_weapon.connect("attacked", self, "attack")
	add_child(_weapon)

func attack(hitArea, damage):
	pass

func setTarget(target):
	.setTarget(target)
	_weapon.setTarget(target)

func _input(event):
	var newMovementSpeed = _movementSpeed;
	if (event.is_action_pressed("move_up")):
		_movementMask |= MovementMaskValues.UP
		newMovementSpeed.y = -250
	if (event.is_action_pressed("move_down")):
		_movementMask |= MovementMaskValues.DOWN
		newMovementSpeed.y = 250
	if (event.is_action_pressed("move_left")):
		_movementMask |= MovementMaskValues.LEFT
		newMovementSpeed.x = -250
	if (event.is_action_pressed("move_right")):
		_movementMask |= MovementMaskValues.RIGHT
		newMovementSpeed.x = 250
		
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
	
	._process(delta)
	setTarget(target)
	updateAnimation()
