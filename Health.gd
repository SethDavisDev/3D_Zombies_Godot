extends Node


export(float) var max_health = 10
var current_health

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health

func delta(amount, increase):
	if !increase:
		print("you're losing health")
		amount *= -1
		print(amount)
	current_health = max(0, min(current_health + amount, max_health))
	print(current_health)
