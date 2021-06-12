extends KinematicBody2D

var velocity = Vector2()
var space_state = null
var rays = null
var on_left = false
var on_right = false
var grounded_left = false
var grounded_right = false
var near_left = false
var near_right = false
var air_speed = 500
var air_accel = 10
var walk_speed = 300
var climb_speed = 300
var slide_speed = 50
var gravity = 10
var jump_count = 1
var max_jumps = 1
var jumph = 400
var jumpv = 400

func _ready():
	rays = []

func _draw():
	for ray in rays:
		if test_ray(space_state, ray):
			draw_line(ray[0], ray[1], Color.red)
		else:
			draw_line(ray[0], ray[1], Color.green)

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
	var down = Vector2.DOWN * 30
	var offset = Vector2.RIGHT * 30
	var hpad = Vector2.RIGHT * 5
	
	rays.clear()
	# on_right
	on_right = test_rays(space_state, [
		[offset * 2.5 + down, down],
		[offset * 2.5 - down, - down]
	])
	if on_right or near_right:
		near_right = test_rays(space_state, [
			[offset * 5, Vector2.ZERO]
		])
	
	# on_left
	on_left = test_rays(space_state, [
		[-offset * 2.5 + down, down],
		[-offset * 2.5 - down, - down]
	])
	
	# grounded_right
	grounded_right = test_rays(space_state, [
		[offset * 0.5, offset * 0.5 + down * 1.6],
		[offset * 2, offset * 2 + down * 1.6]
	])
	
	# grounded_left
	grounded_left = test_rays(space_state, [
		[-offset * 0.5, -offset * 0.5 + down * 1.6],
		[-offset * 2, -offset * 2 + down * 1.6]
	])
	
	if on_left or near_left:
		near_left = test_rays(space_state, [
			[-offset * 5, Vector2.ZERO]
		])
	if grounded_left:
		near_left = false
	if grounded_right:
		near_right = false
	update()
	#var testLeft = space_state.intersect_ray(self.position - offset, probe - offset, [self])
	#var testRight = space_state.intersect_ray(self.position + offset, probe + offset, [self])
	#is_grounded = len(testLeft) != 0 or len(testRight) != 0
	
func get_movement(post = ""):
	var vel = Vector2()
	if Input.is_action_pressed("left" + post):
		vel.x = -1
	if Input.is_action_pressed("right" + post):
		vel.x = 1
	if Input.is_action_pressed("up" + post):
		vel.y = -1
	if Input.is_action_pressed("down" + post):
		vel.y = 1
	return vel
	
func combine_vel(vell, velr):
	var vel = Vector2()
	if grounded_left or on_left:
		vel += vell
	if grounded_right or on_right:
		vel += velr
	if not (grounded_right or grounded_left or on_left or on_right):
		vel = vell + velr
	return vel
	
func handle_movement(vel):
	if grounded_left or grounded_right:
		velocity.x = vel.x * walk_speed
		jump_count = max_jumps
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jumph
	else:
		if velocity.x < -air_speed:
			pass
			velocity.x = -air_speed
		elif velocity.x > air_speed:
			pass
			velocity.x = air_speed
		else:
			velocity.x += vel.x * air_accel
	
	if on_left or on_right:
		if vel.y == 0:
			velocity.y = slide_speed
		elif vel.y < 0:
			velocity.y = vel.y * climb_speed
		else:
			velocity.y = vel.y * climb_speed + slide_speed
	else:
		velocity.y += gravity

	if on_left or on_right or near_left or near_right:
		if Input.is_action_just_pressed("jump"):
			if on_left or near_left:
				velocity.x = jumph
			else:
				velocity.x = -jumph
			velocity.y = -jumpv
		jump_count = max_jumps
	
	if not (grounded_left or grounded_right or on_left or on_right) and jump_count > 0 and Input.is_action_just_pressed("jump"):
		velocity.y = - jumph
		jump_count -= 1

func handle_animate(vel):
	if on_left and vel.y != 0:
		if not ($LeftPlayer.playing and $LeftPlayer.animation == "climb"):
			$LeftPlayer.play("climb")
	elif grounded_left and vel.x != 0:
		if not ($LeftPlayer.playing and $LeftPlayer.animation == "climb"):
			$LeftPlayer.play("climb")
	else:
		$LeftPlayer.stop()
		
	if on_right and vel.y != 0:
		if not ($RightPlayer.playing and $RightPlayer.animation == "climb"):
			$RightPlayer.play("climb")
	elif grounded_right and vel.x != 0:
		if not ($RightPlayer.playing and $RightPlayer.animation == "climb"):
			$RightPlayer.play("climb")
	else:
		$RightPlayer.stop()
	
func _physics_process(delta):
	probe_check()
	#var vel = get_movement()
	var vell = get_movement("l")
	var velr = get_movement("r")
	var vel = combine_vel(vell, velr)
	handle_movement(vel)
	handle_animate(vel)
	velocity = move_and_slide(velocity)
