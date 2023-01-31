extends Node

var WorldScene: PackedScene = preload("res://world/World.tscn")
var world_count: int = 0

onready var lobby = $Lobby
onready var players = $Players


func _ready() -> void:
	lobby.connect("start_game", self, "on_start_game")


func on_start_game() -> void:
	world_count += 1
	var world = create_world()
	prepare_recipes(world)
	prepare_tools(world)
	if Network.pid == 1:
		prepare_world(world)
	world.start_game()
	

func create_world() -> GameWorld:
	var world = WorldScene.instance()
	world.name = "World" + str(world_count)
	add_child(world, true)
	G.set_world(world)
	remove_child(players)
	world.get_node("Players").replace_by(players)
	return world


func prepare_recipes(world: GameWorld) -> void:
	# Recipes
	world.recipe_list = ["pizza"]
	world.ingredient_options = []
	world.tool_options = []
	# Setup list of all ingredients in game
	for recipe_name in world.recipe_list:
		for ingredients in Data.recipes[recipe_name]:
			for ingredient in ingredients:
				if not world.ingredient_options.has(ingredient):
					world.ingredient_options.append(ingredient)


func prepare_tools(world: GameWorld) -> void:
	# Setup list of all tools in game
	world.tool_options.append("Plate")
	world.tool_options.append("CuttingBoard")


func prepare_world(world: GameWorld) -> void:
	# player_items = {
	# 	1: ["plate", "cutting_board", "tomato"],
	#  	pid: [tools, ingredients]}
	var player_tools = {}
	var player_boxes = {}
	
	# Assign all available tools to players
	var pids = []
	for player in players.get_children():
		pids.append(int(player.name))
	
	for pid in pids:
		player_tools[pid] = []
		player_boxes[pid] = []
		for cook_tool in world.tool_options:
			player_tools[pid].append(cook_tool)
		
	# Assign ingredients for spawnbox to players
	var ingredient_options = world.ingredient_options as Array
	ingredient_options.shuffle()
	var pid_index = 0
	while not ingredient_options.empty():
		var pid = pids[pid_index]
		player_boxes[pid].append(ingredient_options.pop_back())
		pid_index += 1
		pid_index = pid_index % pids.size()
	
	for pid in player_tools:
		for cook_tool in player_tools[pid]:
			world.items.rpc_id(pid, "spawn_tool", cook_tool)
	
	for pid in player_boxes:
		for ingredient_type in player_boxes[pid]:
			world.items.rpc_id(pid, "spawn_box", ingredient_type)
	
