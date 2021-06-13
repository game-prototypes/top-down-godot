extends Line2D

class_name BulletTrail

func set_path(origin:Vector2, target:Vector2):
	clear_points()
	add_point(origin)
	add_point(target)

func _on_animation_finished(_anim_name):
	queue_free()
