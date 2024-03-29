extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.root = ["strength", "dexterity", "intellect", "will"]
	arr.branch = ["volume", "replenishment", "tension", "resistance", "onslaught", "reaction", "inspection"]
	arr.indicator = ["health", "endurance"]
	arr.role = ["offensive", "defensive"]
	arr.side = ["left", "right"]


func init_num() -> void:
	num.index = {}
	
	num.area = {}
	num.area.n = 9
	num.area.col = num.area.n
	num.area.row = num.area.n
	
	num.aspect = {}
	num.aspect.min = 1
	num.aspect.avg = 10
	num.aspect.max = 5
	num.aspect.total = arr.root.size() * arr.branch.size() * num.aspect.avg
	num.aspect.gap = 4
	
	num.predisposition = {}
	num.predisposition.min = 0
	num.predisposition.avg = 5
	num.predisposition.max = 10
	
	num.channel = {}
	num.channel.n = 3


func init_dict() -> void:
	init_neighbor()
	init_multipliers()
	init_phase()
	init_markers()
	init_aspects()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_multipliers() -> void:
	dict.multipliers = {}
	dict.multipliers["strength"] = {}
	dict.multipliers["strength"]["health"] = 8
	dict.multipliers["strength"]["endurance"] = 2
	dict.multipliers["dexterity"] = {}
	dict.multipliers["dexterity"]["health"] = 7
	dict.multipliers["dexterity"]["endurance"] = 3
	dict.multipliers["intellect"] = {}
	dict.multipliers["intellect"]["health"] = 1
	dict.multipliers["intellect"]["endurance"] = 9
	dict.multipliers["will"] = {}
	dict.multipliers["will"]["health"] = 4
	dict.multipliers["will"]["endurance"] = 6
	
	#dict.multipliers.volume = {}
	#dict.multipliers.volume["ethos"] = {}
	#dict.multipliers.volume["ethos"]["health"] = 8
	#dict.multipliers.volume["ethos"]["endurance"] = 2
	#dict.multipliers.volume["kairos"] = {}
	#dict.multipliers.volume["kairos"]["health"] = 7
	#dict.multipliers.volume["kairos"]["endurance"] = 3
	#dict.multipliers.volume["logos"] = {}
	#dict.multipliers.volume["logos"]["health"] = 1
	#dict.multipliers.volume["logos"]["endurance"] = 9
	#dict.multipliers.volume["pathos"] = {}
	#dict.multipliers.volume["pathos"]["health"] = 4
	#dict.multipliers.volume["pathos"]["endurance"] = 6


func init_phase() -> void:
	dict.phase = {}
	dict.phase.primary = ["lion", "wolf", "bear", "owl"]
	dict.phase.secondary = ["eagle", "deer", "snake"]
	
	dict.phase.next = {}
	var keys = ["primary", "secondary"]
	
	for key in keys:
		var n = dict.phase[key].size()
		
		for _i in n:
			var current = dict.phase[key][_i]
			var _j = (_i + 1) % n
			var next = dict.phase[key][_j]
			dict.phase.next[current] = next
	
	dict.phase.next["empty"] = "eagle"
	
	#dict.phase.planet = ["schedule encounters", "convene encounters", "take damage" ] 
	#dict.phase.encounter = ["advantage determination", "capacity determination", "take damage"]


func init_markers() -> void:
	dict.marker = {}
	dict.marker.locked = []
	dict.marker.unlocked = []
	
	for _i in 4:
		dict.marker.unlocked.append(_i)


func init_aspects() -> void:
	dict.aspect = {}
	dict.aspect.role = {}
	dict.aspect.role["eagle"] = {}
	dict.aspect.role["eagle"]["offensive"] = "onslaught"
	dict.aspect.role["eagle"]["defensive"] = "reaction"
	dict.aspect.role["deer"] = {}
	dict.aspect.role["deer"]["offensive"] = "tension"
	dict.aspect.role["deer"]["defensive"] = "resistance"
	
	dict.aspect.weight = {}
	dict.aspect.weight["volume"] = 12
	dict.aspect.weight["replenishment"] = 9
	dict.aspect.weight["tension"] = 16
	dict.aspect.weight["resistance"] = 8
	dict.aspect.weight["onslaught"] = 12
	dict.aspect.weight["reaction"] = 6
	dict.aspect.weight["inspection"] = 7
	
	for branch in arr.branch:
		dict.aspect.weight[branch] = round(dict.aspect.weight[branch] * 100 / (num.aspect.avg * arr.branch.size()))#* num.aspect.total / 100.0)
	


func init_blank() -> void:
	dict.blank = {}
	dict.blank.rank = {}
	var exceptions = ["rank"]
	
	var path = "res://asset/json/maoiri_blank.json"
	var array = load_data(path)
	
	for blank in array:
		blank.rank = int(blank.rank)
		var data = {}
		
		for key in blank:
			if !exceptions.has(key):
				data[key] = blank[key]
			
		if !dict.blank.rank.has(blank.rank):
			dict.blank.rank[blank.rank] = []
	
		dict.blank.rank[blank.rank].append(data)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.token = load("res://scene/0/token.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.area = load("res://scene/2/area.tscn")
	
	scene.aspect = load("res://scene/3/aspect.tscn")
	
	scene.dice = load("res://scene/4/dice.tscn")
	scene.facet = load("res://scene/4/facet.tscn")
	
	
	scene.challenge = load("res://scene/5/challenge.tscn")
	scene.challenger = load("res://scene/5/challenger.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	vec.size.area = Vector2(60, 60)
	vec.size.token = Vector2(48, 48)
	vec.size.bar = Vector2(128, 16)
	vec.size.facet = Vector2(vec.size.token)
	vec.size.shedule = Vector2(vec.size.token.x * 4, vec.size.token.y)
	vec.size.encounter = Vector2(vec.size.token.x * 6, vec.size.token.y)
	vec.size.channel = Vector2(vec.size.token.x * num.channel.n - 1, vec.size.token.y)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(30 / h, 0.9, 0.7)
	color.indicator.health.background = Color.from_hsv(30 / h, 0.5, 0.9)
	color.indicator.endurance = {}
	color.indicator.endurance.fill = Color.from_hsv(270 / h, 0.9, 0.7)
	color.indicator.endurance.background = Color.from_hsv(270 / h, 0.5, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
