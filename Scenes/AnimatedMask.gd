extends Sprite2D


@export var speed : float = 1
var timer : float = 0

var index : int = 0

func _ready():
	CandleManager.candle_collected.connect(_on_candle_collected)

func _on_candle_collected():
	scale *= 1.5

func _process(delta):
	timer +=  delta
	if timer < (1/speed)  : return
	else : timer = 0
	
	index += 1
	if index >= hframes : index = 0

	frame = index
