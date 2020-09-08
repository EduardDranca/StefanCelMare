extends Node2D

signal attacked(hitArea, damage)

export(int) var _baseDamage

var _damage

func _setDamage(damage):
	_damage = damage

func _attack():
	emit_signal("attacked", $HitArea, _damage)
