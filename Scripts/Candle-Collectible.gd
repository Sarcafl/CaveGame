extends Node2D

class_name CandleCollectible



func _on_area_2d_body_entered(body):
	if body.name != "Guy": return
	CandleManager._candleCollected()
	hide()
