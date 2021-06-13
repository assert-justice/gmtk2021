extends Area2D

func _draw():
	var rect = Rect2(-$CollisionShape2D.shape.extents, $CollisionShape2D.shape.extents * 2)
	draw_rect(rect, Color.red)
