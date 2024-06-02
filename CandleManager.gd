extends Node

signal candle_collected

func _candleCollected():
	candle_collected.emit()
