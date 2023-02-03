extends Node

# The order of ingredients when assembled on a plate is important
# Ensure the main recipe's list of ingredients is listed first in the array
var recipes : Dictionary = {
	"pizza":[
		["dough", "tomato", "cheese", "mushroom"],
		["dough", "tomato", "cheese"],
		["dough", "tomato", "mushroom"],
		["dough", "tomato"]
	]
}


