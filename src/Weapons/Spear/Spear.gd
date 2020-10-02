extends "res://src/Weapons/Weapon.gd"

const _attackDistance = 50
onready var _attackAnimationHalfDuration = _attackAnimationDuration / 2
var _animationTimer = 0

func _process(delta):
	._process(delta)
	if (_isAttacking):
		updateAnimation(delta)

func _ready():
	._ready()
	$AnimationPlayer.connect("animation_finished", self, "resetTimer")

func resetTimer(animationName):
	if (animationName == "attack"):
		_animationTimer = 0
		$WeaponSprite.position = Vector2(0, 0)

func updateAnimation(delta):
	_animationTimer += delta
	var positionDelta = _attackDistance * (delta / _attackAnimationHalfDuration)
	if (_animationTimer > _attackAnimationHalfDuration):
		$WeaponSprite.position.x -= positionDelta
	else:
		$WeaponSprite.position.x += positionDelta
