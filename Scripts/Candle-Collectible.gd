extends Node2D

class_name CandleCollectible

var collected = false


func _on_area_2d_body_entered(body):
	if body.name != "Guy" || collected : return
	collected = true
	CandleManager._candleCollected()
	hide()
