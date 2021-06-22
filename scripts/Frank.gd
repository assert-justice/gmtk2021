extends Area2D

var velocity = Vector2()
var speed = 800
var accel = 100
var rays = null
var space_state = null
var on_left = false
var on_right = false
var rect_width = 72 * 4
var rect_height = 72 * 4
var rect_points = null
var current_point = 0
var close_enough = 50
var turn_speed = 4 * PI

var time = 4.5
var beat_length = 60.0 / 110.0
var move_time = 8

func _ready():
	rays = []
	velocity = Vector2.RIGHT * speed
	move_time *= beat_length
	time *= beat_length
	rect_points = [
		position,
		position + Vector2.DOWN * rect_height,
		position + Vector2.DOWN * rect_height + Vector2.RIGHT * rect_width,
		position + Vector2.RIGHT * rect_width
	]

func test_ray(state, ray):
	return len(state.intersect_ray(self.position + ray[0], self.position + ray[1], [self])) != 0

func test_rays(state, temp_rays):
	rays += temp_rays
	for ray in temp_rays:
		if test_ray(state, ray):
			return true
	return false

func probe_check():
	space_state = get_world_2d().direct_space_state
	on_left = test_rays(space_state, [[Vector2.ZERO, Vector2.LEFT * 55]])
	on_right = test_rays(space_state, [[Vector2.ZERO, Vector2.RIGHT * 55]])
	
func kickoff():
	current_point += 1
	if current_point == len(rect_points):
		current_point = 0
	velocity = position.direction_to(rect_points[current_point]) * accel

func _physics_process(delta):
	probe_check()
	#if velocity.length() > 0 and velocity.length() < speed:
		#velocity += velocity.normalized() * accel
	if velocity.length() > 0 and (position - rect_points[current_point]).length() < close_enough:
		position = rect_points[current_point]
		velocity = Vector2.ZERO
	if velocity.length() > 0 and velocity.length() < speed:
		velocity += velocity.normalized() * accel
	if time > 5 * beat_length or velocity.length() > 0:
		rotate(turn_speed * delta)
	position += velocity * delta
	#update()
	time += delta
	if time > move_time:
		time -= move_time
		kickoff()

func _draw():
	var rad = $CollisionShape2D.shape.radius
	var body_rad = rad * 0.4
	var hand_rad = rad * 0.2
	var arm_width = rad * 0.1
	var hand_dist = rad * 0.8
	
	#draw_circle(Vector2.ZERO, rad, Color.red)
	draw_circle(Vector2.ZERO, body_rad, Color.black)
	draw_rect(Rect2(-Vector2.ONE * hand_rad, Vector2.ONE * hand_rad * 2), Color.red)
	var vec = Vector2.RIGHT
	for i in range(6):
		var pos = vec * hand_dist
		draw_circle(pos, hand_rad, Color.black)
		draw_line(Vector2.ZERO, pos, Color.black, arm_width)
		vec = vec.rotated(deg2rad(60))


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()


func _on_Frank_body_entered(body):
	if body.is_in_group("player"):
		body.emit_signal("kill")
