extends Node2D

onready var player = $Stefan

func _ready():
	$Spawner.connect("spawned", self, "connectEnemy")
	$Stefan.connect("requestSound", $SoundManager, "playSound")

func connectEnemy(enemy):
	if ($Stefan):
		$Stefan.connect("moved", enemy, "updatePlayerPosition")
	enemy.connect("requestSound", $SoundManager, "playSound")
