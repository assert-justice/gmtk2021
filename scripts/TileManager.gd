extends Node2D

export var use_advanced = false
export var chunks_used = 0
export var floor_height = 18 * 72

var flr = null
var pool = []
var player = null
var in_use = []
var advanced = []
var start = []

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
		chunks_used += 1
		for obj in get_parent().get_children():
			if obj != self:
				obj.position.y += floor_height
		for obj in get_children():
			obj.position.y += floor_height
		var temp = in_use.pop_front()
		if temp != flr:
			pool.append(temp)
		var new_chunk
		if len(start) > 0:
			new_chunk = start.pop_front()
			if len(start) == 0:
				use_advanced = true
		else:
			while true:
				var idx = rand_range(0, len(pool))
				new_chunk = pool[idx]
				if not new_chunk in in_use:
					pool.remove(idx)
					break
		new_chunk.position.y = in_use[-1].position.y - floor_height
		new_chunk.position.x = 0
		in_use.push_back(new_chunk)
		get_tree().get_nodes_in_group("deathbox")[0].position.y = in_use[0].position.y
