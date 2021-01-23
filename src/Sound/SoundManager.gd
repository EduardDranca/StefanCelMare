extends Node2D

onready var SoundDictionary = {
	"sword_attack" : $Weapons/Sword/Attack,
	"sword_hit" : $Weapons/Sword/Hit,
	"spear_attack" : $Weapons/Spear/Attack,
	"spear_hit" : $Weapons/Spear/Hit
}

var soundsPlayed = {}
var soundsPlaying = []
func _ready():
	pass

func playSound(sound, position):
	if soundsPlayed.get(sound) == null:
		soundsPlayed[sound] = position

func _process(delta):
	var lenSoundsPlaying = len(soundsPlaying)
	
	var idx = 0
	while idx < lenSoundsPlaying:
		if !soundsPlaying[idx].playing:
			remove_child(soundsPlaying[idx])
			soundsPlaying.remove(idx)
			lenSoundsPlaying = len(soundsPlaying)
		else:
			idx += 1
		

	for sound in soundsPlayed.keys():
		var soundNode = SoundDictionary.get(sound).duplicate()
		add_child(soundNode)
		soundNode.position = soundsPlayed.get(sound)
		soundNode.play()
		soundsPlaying.append(soundNode)
	soundsPlayed.clear()
