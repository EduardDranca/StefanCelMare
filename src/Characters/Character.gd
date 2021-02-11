extends KinematicBody2D

enum Orientation {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum MovementMaskValues {
	NO_MOVEMENT = 0,
	UP = 1,
	DOWN = 2,
	LEFT = 4,
	RIGHT = 8
}

const moveAnimationDictionary = {
	Orientation.UP: "walk_up",
	Orientation.DOWN: "walk_down",
	Orientation.RIGHT: "walk_right",
	Orientation.LEFT: "walk_right"
}

const idleAnimationDictionary = {
	Orientation.UP: "idle_up",
	Orientation.DOWN: "idle_down",
	Orientation.RIGHT: "idle_right",
	Orientation.LEFT: "idle_right"
}

const deathAnimation = "death"

const _hitAnimationTotalTime = 0.15
var _hitAnimationTime = 0.0
var _isHit = false

export(bool) var _hittable = false
export(int) var _hitPoints = 0
var _currentHitPoints
var _kill = false
var _isDead = false
var _movementMask = 0
var _isMoving = false
var _orientation = Orientation.RIGHT

var _movementSpeed = Vector2()
var _deceleration = Vector2(2000, 2000)

var _target = Vector2()

onready var AnimationPlayer = $AnimationPlayer
onready var CharacterSprite = $Sprite

signal requestSound(sound, position)
signal death

func _ready():
	_currentHitPoints = _hitPoints
	var mat = CharacterSprite.get_material().duplicate(true)
	CharacterSprite.set_material(mat)
	mat = $HPBar.get_material().duplicate(true)
	$HPBar.set_material(mat)
	if (_hittable):
		CharacterSprite.material.set_shader_param("hitAnimationTotalTime", _hitAnimationTotalTime)
#	AnimationPlayer.connect("animation_finished", self, "checkAnimationStop")

#func checkAnimationStop(animationName):
#	if (animationName == deathAnimation):
#		emit_signal()
#		queue_free()

func hit(damage):
	if (_hittable):
		_isHit = true
		_currentHitPoints -= damage
		$HPBar.setRatio(float(_currentHitPoints) / _hitPoints)
		$HPBar.display()
		if (_currentHitPoints <= 0):
			_kill = true
			_currentHitPoints = 0

func updateSpeed(delta):
	if (_movementMask & MovementMaskValues.LEFT == 0 and
		_movementMask & MovementMaskValues.RIGHT == 0 and
		_movementSpeed.x != 0):
		var newMovementSpeed = _movementSpeed
		var signX = sign(newMovementSpeed.x)
		newMovementSpeed.x -= signX * _deceleration.x * delta
		
		if (sign(newMovementSpeed.x) != signX):
			newMovementSpeed.x = 0
		
		setMovementSpeed(newMovementSpeed)
	if (_movementMask & MovementMaskValues.UP == 0 and
		_movementMask & MovementMaskValues.DOWN == 0 and
		_movementSpeed.y != 0):
		var newMovementSpeed = _movementSpeed
		var signY = sign(newMovementSpeed.y)
		newMovementSpeed.y -= signY * _deceleration.y * delta
		
		if (sign(newMovementSpeed.y) != signY):
			newMovementSpeed.y = 0
		
		setMovementSpeed(newMovementSpeed)

func updatePosition():
	move_and_slide(_movementSpeed)

func calculateOrientation():
	if (abs(_target.x) < abs(_target.y)):
		if _target.y < 0:
			_orientation = Orientation.UP
		else:
			_orientation = Orientation.DOWN
	else:
		if _target.x < 0:
			_orientation = Orientation.LEFT
		else:
			_orientation = Orientation.RIGHT

func updateMovementMask(movementSpeed):
	if (movementSpeed.x > 0):
		_movementMask |= MovementMaskValues.RIGHT
	elif (movementSpeed.x < 0):
		_movementMask |= MovementMaskValues.LEFT
	if (movementSpeed.y > 0):
		_movementMask |= MovementMaskValues.DOWN
	elif (movementSpeed.y < 0):
		_movementMask |= MovementMaskValues.UP

func clearMovementMask():
	_movementMask = 0

func setMovementSpeed(movementSpeed):
	_movementSpeed = movementSpeed
	if (_movementSpeed.is_equal_approx(Vector2(0, 0))):
		_movementSpeed = Vector2(0, 0)
		_isMoving = false
	else:
		_isMoving = true

func setTarget(target):
	_target = target - position
	calculateOrientation()

func updateAnimation():
	if (_orientation == Orientation.LEFT):
		CharacterSprite.flip_h = true
	elif (_orientation == Orientation.RIGHT):
		CharacterSprite.flip_h = false
	if (_isMoving):
		AnimationPlayer.play(moveAnimationDictionary.get(_orientation))
	else:
		AnimationPlayer.play(idleAnimationDictionary.get(_orientation))

func checkIfDead():
	if (_kill):
		if (AnimationPlayer.has_animation(deathAnimation)):
			AnimationPlayer.play(deathAnimation)
		else:
			emit_signal("death")
			queue_free()
		return true
	return false

func updateHitMaterial(delta):
	_hitAnimationTime += delta
	if (_hitAnimationTime >= _hitAnimationTotalTime):
		_hitAnimationTime = 0
		_isHit = false
	CharacterSprite.material.set_shader_param("hitAnimationTime", _hitAnimationTime)

#func getGlobalPosition():
#	return get_global_transform_with_canvas().get_origin() 

# the soundPosition is the position of the sound relative to the character
func playSound(sound, soundPosition):
	emit_signal("requestSound", sound, position + soundPosition)
	
func _process(delta):
	if (_isHit):
		updateHitMaterial(delta)
	if (!_isDead):
		_isDead = checkIfDead()
	if (_isDead):
		return
	updatePosition()
	updateSpeed(delta)
	updateAnimation()
