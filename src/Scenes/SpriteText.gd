extends Node2D

onready var letterMap = {}
onready var frameSize = Vector2()
export(int) onready var lineSpacing

func _ready():
	var i = 0
	var xIndex = 0
	var yIndex = 0
	var text = $Text.text
	var characters = $CharactersOrder.text
	frameSize = Vector2($Sprite.texture.get_size().x / $Sprite.hframes, $Sprite.texture.get_size().y / $Sprite.vframes)
	frameSize.x *= $Sprite.scale.x
	frameSize.y *= $Sprite.scale.y
	print(frameSize)
	
	for c in characters:
		letterMap[c] = i
		i += 1
	
	for c in text:
		var sprite = $Sprite.duplicate()
		if (c == '\n'):
			xIndex = 0
			yIndex += 1
		else:
			if (c != ' '):
				sprite.frame = letterMap[c]
				sprite.position.x = xIndex * frameSize.x
				sprite.position.y = yIndex * (frameSize.y + lineSpacing)
				sprite.visible = true
				add_child(sprite)
			xIndex += 1
