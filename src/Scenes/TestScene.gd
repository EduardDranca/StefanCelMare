extends Node2D

onready var player = $Stefan

func _ready():
	$Spawner.connect("spawned", self, "connectEnemy")

func connectEnemy(enemy):
	$Stefan.connect("moved", enemy, "updatePlayerPosition")
