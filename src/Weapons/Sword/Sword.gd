extends "res://src/Weapons/Weapon.gd"

var _flipRotation = false
var _swordRotation = 0

func _ready():
	._ready()
	$AnimationPlayer.connect("animation_finished", self, "flipRotation")

func _process(delta):
	._process(delta)
	if (_isAttacking):
		updateAnimation(delta)

func flipRotation(animationName):
	if (animationName == "attack"):
		if (_flipRotation):
			$WeaponSprite.rotation = 0
		else:
			$WeaponSprite.rotation = PI
		_flipRotation = !_flipRotation

func updateAnimation(delta):
	if (_flipRotation):
		_swordRotation -= (delta / _attackAnimationDuration) * PI
	else:
		_swordRotation += (delta / _attackAnimationDuration) * PI
	
	if (_swordRotation < 0):
		_swordRotation = 0
	if (_swordRotation > PI):
		_swordRotation = PI
	
	$WeaponSprite.rotation = _swordRotation
