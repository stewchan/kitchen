extends Node

var recipes : Dictionary = {
	"Salad": [
		["Lettuce"],
		["Lettuce", "Tomato"],
	],
	"Soup": [
		["Tomato"],
		["Eggplant"],
		["Lettuce"],
		["Tomato", "Eggplant", "Lettuce"]
	],
}

var textures: Dictionary = {
	"Tomato": {
		"raw":"res://addons/kenney_prototype_textures/red/texture_01.png",
		"progress":"res://addons/kenney_prototype_textures/red/texture_11.png",
		"prepped":"res://addons/kenney_prototype_textures/red/texture_13.png",
	},
	"Lettuce": {
		"raw":"res://addons/kenney_prototype_textures/green/texture_01.png",
		"progress":"res://addons/kenney_prototype_textures/green/texture_11.png",
		"prepped":"res://addons/kenney_prototype_textures/green/texture_13.png"
	},
	"Eggplant": {
		"raw":"res://addons/kenney_prototype_textures/purple/texture_01.png",
		"progress":"res://addons/kenney_prototype_textures/purple/texture_11.png",
		"prepped":"res://addons/kenney_prototype_textures/purple/texture_13.png"
	}
}

