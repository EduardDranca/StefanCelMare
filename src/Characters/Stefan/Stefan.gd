extends "res://src/Characters/Character.gd"

var _weaponDictionary = WeaponPathDictionary.weaponScenesDictionary
var _swordPackedScene = _weaponDictionary.get("sword")
var _weapon = _swordPackedScene.instance()

func _ready():
	_weapon._setDamage(100)
	_weapon.connect("attacked", self, "_getHit")
	add_child(_weapon)

func _getHit(hitArea, damage):
	for overlappingBody in hitArea.get_overlapping_bodies():
		print(overlappingBody)
	print(damage)

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
		_weapon._attack()
		
	if (event.is_action_released("move_up")):
		_movementMask &= ~MovementMaskValues.UP
	if (event.is_action_released("move_down")):
		_movementMask &= ~MovementMaskValues.DOWN
	if (event.is_action_released("move_left")):
		_movementMask &= ~MovementMaskValues.LEFT
	if (event.is_action_released("move_right")):
		_movementMask &= ~MovementMaskValues.RIGHT
		
	._setMovementSpeed(newMovementSpeed)

func _updateAnimation():
	if (_orientation == Orientation.LEFT):
		get_node("Sprite").flip_h = true
	elif (_orientation == Orientation.RIGHT):
		get_node("Sprite").flip_h = false
	if (_isMoving):
		get_node("AnimationPlayer").play(moveAnimationDictionary.get(_orientation))
	else:
		get_node("AnimationPlayer").play(idleAnimationDictionary.get(_orientation))

func _process(delta):
	var target = get_global_mouse_position() - position
	
	._process(delta)
	._setTarget(target)
	_updateAnimation()
