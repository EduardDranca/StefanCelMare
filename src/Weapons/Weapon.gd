extends Node2D

signal attacked(hitArea, damage)

export(int) var _baseDamage

var _target
var _damage
var _parentZIndex

func setDamage(damage):
	_damage = damage

func setTarget(target):
	_target = target

func _process(delta):
	if (!$AnimationPlayer.is_playing()):
		$AttackSprite.visible = false

func updateRotation():
	rotation = Vector2(1, 0).angle_to(_target);
	if (rotation < 0):
		rotation += 2 * PI
	if (rotation >= PI / 2
		and rotation <= 3 * PI / 2):
		z_index = 1
	elif (rotation < PI / 2
		or rotation > 3 * PI / 2):
		z_index = -1

func attack():
	emit_signal("attacked", $HitArea, _damage)
	if ($AnimationPlayer.has_animation("attack")):
		$AttackSprite.visible = true
		$AnimationPlayer.play("attack")
