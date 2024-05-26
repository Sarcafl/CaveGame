extends Sprite2D


@export var speed : float = 1
var timer : float = 0

var index : int = 0

func _process(delta):
	timer +=  delta
	if timer < (1/speed)  : return
	else : timer = 0
	
	index += 1
	if index >= hframes : index = 0

	frame = index
