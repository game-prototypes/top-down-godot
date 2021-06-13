extends Line2D

class_name Bullet

func set_path(_origin:Vector2, _target:Vector2):
	clear_points()
	add_point(_origin)
	add_point(_target)

func _on_animation_finished(anim_name):
	queue_free()
