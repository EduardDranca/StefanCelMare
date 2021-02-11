extends Node2D

onready var player = $Stefan

func _ready():
	$Spawner.connect("spawned", self, "connectEnemy")
	$Stefan.connect("requestSound", $SoundManager, "playSound")
	$Stefan.connect("playerDeath", self, "playerDeath")

func playerDeath(camera):
	camera.position = camera.get_parent().position
	camera.get_parent().remove_child(camera)
	self.add_child(camera)

func connectEnemy(enemy):
	if ($Stefan):
		$Stefan.connect("moved", enemy, "updatePlayerPosition")
	enemy.connect("requestSound", $SoundManager, "playSound")
