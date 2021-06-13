extends KinematicBody2D

var time = 0
var beat_length = 60.0 / 110.0
var danger = false
var danger_on = 8
var danger_off = 8

func _ready():
	pass
	time = beat_length * 4.25
	danger_on *= beat_length
	danger_off *= beat_length
	print(danger_on + danger_off)
	
func _process(delta):
	time += delta
	#print(time)
	if time > danger_on + danger_off:
		time -= danger_on + danger_off
		set_danger(false)
	elif time > danger_off:
		set_danger(true)

func set_danger(dan):
	danger = dan
	$DamageBox/CollisionShape2D.disabled = not danger
	if danger:
		$DamageBox.scale = Vector2.ONE * 0.5
		$DamageBox.rotation = PI * 0.25
	else:
		$DamageBox.scale = Vector2.ONE
		$DamageBox.rotation = 0
		

func _draw():
	var hw = $CollisionShape2D.shape.extents.x
	var pad = hw * 0.2
	var pts = [
		Vector2(-hw, -hw + pad),
		Vector2(-hw + pad, -hw),
		
		Vector2(hw - pad, -hw),
		Vector2(hw, -hw + pad),
		
		Vector2(hw, hw - pad),
		Vector2(hw - pad, hw),
		
		Vector2(-hw + pad, hw),
		Vector2(-hw, hw - pad),
	]
	var points = PoolVector2Array(pts)
	var colors = PoolColorArray()
	for i in range(len(points)):
		colors.append(Color.blue)
	
	#draw_rect(Rect2(-$CollisionShape2D.shape.extents, $CollisionShape2D.shape.extents * 2), Color.red)
	draw_polygon(points, colors)


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
