extends StaticBody2D

@export var crumble_time = 1.0 #time delay before platform crumbles
@export var max_steps = 2 #nr of steps before falling
@onready var animated_sprite = $AnimatedSprite2D

var step_count = 0
var is_crumbling = false



func _on_area_2d_body_entered(body):
	if body.name == "Guy":
		if !is_crumbling:
			step_count +=1
			if step_count >=max_steps:
				animated_sprite.play("falling")
			else:
				is_crumbling = true
				animated_sprite.play("stepped_on")

func _on_area_2d_body_exited(body):
	if body.name == "Guy":
		is_crumbling = false


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "falling":
		queue_free()
