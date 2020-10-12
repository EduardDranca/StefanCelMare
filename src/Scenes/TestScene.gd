extends Node2D

onready var player = $Stefan

func _ready():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		player.connect("moved", enemy, "updatePlayerPosition")
