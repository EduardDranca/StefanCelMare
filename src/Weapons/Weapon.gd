extends Node2D

signal attacked(hitArea, damage)

const alpha = 0.6

var _target
export(int) var _damage
var _parentZIndex
var _isAttacking
var _attackAnimationDuration

func _ready():
	$AttackSprite.modulate = Color(1, 1, 1, alpha)
	$AnimationPlayer.connect("animation_finished", self, "stopAnimation")
	if ($AnimationPlayer.has_animation("attack")):
		_attackAnimationDuration = $AnimationPlayer.get_animation("attack").length

func setDamage(damage):
	_damage = damage

func setTarget(target):
	_target = target - $WeaponSprite.get_global_transform_with_canvas().get_origin()

func stopAnimation(animationName):
	if (animationName == "attack"):
		_isAttacking = false;
		$AttackSprite.visible = false

func _process(_delta):
	if (!_isAttacking):
		updateRotation()
	checkSpriteRotation()

func checkSpriteRotation():
	var weaponSpriteRotation = rotation + $WeaponSprite.rotation
	if (weaponSpriteRotation < 0):
		weaponSpriteRotation += 2 * PI
	elif (weaponSpriteRotation >= 2 * PI):
		weaponSpriteRotation -= 2 * PI
	if (weaponSpriteRotation >= PI / 2
		and weaponSpriteRotation <= 3 * PI / 2):
		z_index = 1
	elif (weaponSpriteRotation < PI / 2
		or weaponSpriteRotation > 3 * PI /2):
		z_index = -1

func updateRotation():
	rotation = Vector2(1, 0).angle_to(_target);

func attack():
	emit_signal("attacked", $HitArea, _damage)
	if ($AnimationPlayer.has_animation("attack")):
		_isAttacking = true;
		$AttackSprite.visible = true
		$AnimationPlayer.play("attack")
