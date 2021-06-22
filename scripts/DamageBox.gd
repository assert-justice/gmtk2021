extends Area2D

func _draw():
	var rect = Rect2(-$CollisionShape2D.shape.extents, $CollisionShape2D.shape.extents * 2)
	draw_rect(rect, Color.red)


func _on_DamageBox_body_entered(body):
	if body.is_in_group("player"):
		body.emit_signal("kill")
