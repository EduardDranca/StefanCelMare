extends Node2D

signal requestSound(sound, position)

const alpha = 0.6

var _attackSound = ""
var _hitSound = ""

var _target = Vector2(0, 0)
var _enemyGroup = "enemies"
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
	_target = target

func setEnemyGroup(enemyGroup):
	_enemyGroup = enemyGroup

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
	emit_signal("requestSound", _attackSound, position)
	if ($AnimationPlayer.has_animation("attack")):
		_isAttacking = true;
		$AttackSprite.visible = true
		$AnimationPlayer.play("attack")
	
	var hit = false
	for intersectingBody in $HitArea.get_overlapping_bodies():
		if (intersectingBody.is_in_group(_enemyGroup)):
			hit = true
			var enemy = intersectingBody
			enemy.hit(_damage)
			
	if (hit):
		emit_signal("requestSound", _hitSound, position)
