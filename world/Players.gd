extends Node


remotesync func add_recipes(recipe_list: Array) -> void:
	get_parent().recipe_list = recipe_list
	get_parent().ingredient_options = []
	get_parent().tool_options = []
	# Setup list of all ingredients in game
	for recipe_name in recipe_list:
		for ingredients in Data.recipes[recipe_name]:
			for ingredient in ingredients:
				if not get_parent().ingredient_options.has(ingredient):
					get_parent().ingredient_options.append(ingredient)


# Setup list of all tools in game
remotesync func add_tools(tools_list: Array) -> void:
	for kitchen_tool in tools_list:
		get_parent().tool_options.append(kitchen_tool)


remotesync func prepare_boxes() -> void:
	var ingredient_options = get_parent().ingredient_options
	ingredient_options.shuffle()
	var i = 0
	print(get_child(0))
	while not ingredient_options.empty():
		
		var pid = int(get_child(i).name)
		var ingred_type = ingredient_options.pop_back()
		get_parent().items.rpc_id(pid, "spawn_box", ingred_type)
		i += 1
		i = i % get_child_count()


remotesync func prepare_tools() -> void:
	var tool_options = get_parent().tool_options
	for player in get_children():
		var pid = int(player.name)
		for kitchen_tool in tool_options:
			get_parent().items.rpc_id(pid, "spawn_tool", kitchen_tool)


remotesync func prepare_portals() -> void:
	if get_child_count() == 1:
		pass # set portal to point to self
	else:
		for player in get_children():
			# Spawn portals
			pass
#			portal_info[player_count-1] = portal_info[0]
#			for i in range(1, player_count):
#				portal_info[i-1] = i

