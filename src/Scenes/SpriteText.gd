extends Node2D

onready var spriteFont = $SpriteFont
onready var textContainer = $TextContainer
onready var characterMap = {}
onready var frameSize = Vector2()
export(String, MULTILINE) onready var text
export(int) onready var lineSpacing
export(bool) onready var centered
const charactersOrder = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!?\".0123456789:"

func _ready():
	var i = 0
	frameSize = Vector2(spriteFont.texture.get_size().x / spriteFont.hframes, spriteFont.texture.get_size().y / spriteFont.vframes)
	frameSize.x *= spriteFont.scale.x
	frameSize.y *= spriteFont.scale.y
	
	for c in charactersOrder:
		characterMap[c] = i
		i += 1
	
	setText(text)


func setText(newText):
	var xIndex = 0
	var yIndex = 0
	text = newText
		# split the text by lines
	text = text.split("\n")
	
	clearTextContainer()
	
	for line in text:
		var lineLength = line.length()
		xIndex = 0
		
		for c in line:
			var sprite = spriteFont.duplicate()
			if (c != ' '):
				sprite.frame = characterMap[c]
				sprite.position = calculatePosition(xIndex, yIndex, lineLength)
				sprite.visible = true
				textContainer.add_child(sprite)
			xIndex += 1
		yIndex += 1

func clearTextContainer():
	for child in textContainer.get_children():
		child.queue_free()

func calculatePosition(xIndex, yIndex, lineLength):
	var charPosition = Vector2()
	charPosition.y = yIndex * (frameSize.y + lineSpacing)
	if (centered):
		charPosition.x = (xIndex - (lineLength - 1) / 2.0) * frameSize.x
		return charPosition
	charPosition.x = xIndex * frameSize.x 
	return charPosition
