extends CanvasLayer

@onready var colorRect = $ColorRect
@onready var animPlayer = $AnimationPlayer

var fading : bool = false

var fadeTime : float = 0

var timer : float = 0
var startColor = Color(0,0,0,0)
var endColor = Color(0,0,0,1)

func _fade(time : float, fadeBlack : bool, fadeIn : bool):
	if fading : return
	else : fading = true
	
	fadeTime = time
	timer = 0
	
	var c : float = 0
	if not fadeBlack : c = 1
	
	var startAlpha : float = 0
	var endAlpha : float = 1
	if not fadeIn: 
		startAlpha = 1
		endAlpha = 0
	
	startColor = Color(c,c,c,startAlpha)
	endColor = Color(c,c,c,endAlpha)
	
	if animPlayer.is_playing(): animPlayer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not fading: return
	
	if timer > fadeTime :
		fading = false
		return
	
	timer += delta
	colorRect.modulate = (lerp(startColor, endColor, timer/fadeTime))

func _flashRed():
	if not fading : animPlayer.play("flash_red")
