extends OtomanAIState

class_name FollowAIState

var _speed = 20

func update(delta):
	_target.setTarget(_playerPosition)
	_target.moveTo(_playerPosition, _speed)
	return null
