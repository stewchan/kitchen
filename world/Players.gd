extends Node


remotesync func add_recipes(recipe_list: Array) -> void:
	G.recipe_list = recipe_list
	G.ingredient_options = []
	G.tool_options = []
	# Setup list of all ingredients in game
	for recipe_name in recipe_list:
		for ingredients in Data.recipes[recipe_name]:
			for ingredient in ingredients:
				if not G.ingredient_options.has(ingredient):
					G.ingredient_options.append(ingredient)


# Setup list of all tools in game
remotesync func add_tools(tools_list: Array) -> void:
	for kitchen_tool in tools_list:
		G.tool_options.append(kitchen_tool)


func prepare_boxes() -> void:
	var ingredient_options = G.ingredient_options.duplicate()
	ingredient_options.shuffle()
	var i = 0
	print(G.recipe_list)	
	while not ingredient_options.empty():
		var pid = int(get_child(i).name)
		var ingred_type = ingredient_options.pop_back()
		G.world_node.items.rpc_id(pid, "spawn_box", ingred_type)
		i += 1
		i = i % get_child_count()


func prepare_tools() -> void:
	var tool_options = G.tool_options
	for player in get_children():
		var pid = int(player.name)
		for kitchen_tool in tool_options:
			G.world_node.items.rpc_id(pid, "spawn_tool", kitchen_tool)


func prepare_portals() -> void:
	var prev_player = get_children()[0]
	var last_player = get_children()[get_child_count()-1]
	var first_pid = int(prev_player.name)
	var last_pid = int(last_player.name)
	G.world_node.portal.rpc_id(last_pid, "set_peer", first_pid)

	for i in range(1, get_child_count()):
		var cur_player = get_child(i)
		var cur_pid = int(cur_player.name)
		var prev_pid = int(prev_player.name)
		G.world_node.portal.rpc_id(prev_pid, "set_peer", cur_pid)
		prev_player = cur_player


