extends Label


@export var animation_tree = AnimationTree


func _process(delta):
	var current_animation = animation_tree.get("parameters/playback/current_animation")
	if current_animation == null:
		current_animation = "None"
	text = "Animation: " + current_animation
