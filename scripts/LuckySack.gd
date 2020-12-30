extends Node
class_name LuckySack

var score : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_score(number : int):
	score += number
	print("score: " + str(score))
