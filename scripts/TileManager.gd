extends Node2D

export var use_advanced = false

var flr = null
var pool = []
var player = null
var in_use = []
var advanced = []
var start = []
var floor_height = 18 * 72
var chunks_used = 0

func prep_advanced():
	pass

func _ready():
	flr = $Floor
	start = [$Roku, $Frank, $Shimmey, $Frank2, $Frank3]
	pool = []
	#pool = [$Roku2]
	in_use = [$Floor, $Empty, $Empty2]
	for child in get_children():
		if not child in pool and not child in in_use:
			pool.append(child)
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	# if we need a new floor spawned
	if player == null:
		return
	if in_use[-1].position.y > player.position.y:
		# remove second element from array
		#in_use.pop_front()
		var temp = in_use.pop_front()
		temp.position.x = - 15 * 72
		if temp != flr:
			pool.append(temp)
		#in_use.push_front(flr)
		#flr.position.y -= floor_height
		var idx = rand_range(0, len(pool))
		var new_chunk
		if len(start) > 0:
			new_chunk = start.pop_front()
			if len(start) == 0:
				use_advanced = true
		else:
			new_chunk = pool[idx]
			pool.remove(idx)
		new_chunk.position.y = in_use[-1].position.y - floor_height
		new_chunk.position.x = 0
		in_use.push_back(new_chunk)
		get_tree().get_nodes_in_group("deathbox")[0].position.y = in_use[0].position.y
