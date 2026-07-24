extends Node
var hearts = 3


@onready var label: Label = $"../CanvasLayer/Label"
@onready var dialog = $"../AcceptDialog"
@export var hreart : Array[Node]


var points = 0
var apples_left = 0

func halth():
	hearts -= 1
	print(hearts)
	if (hearts == 0):
		call_deferred("_lose")
	for h in 3:
		if (h< hearts):
			hreart[h].show()
		else :
			hreart[h].hide()
func _ready():
	apples_left = get_tree().get_nodes_in_group("apple").size()

func add_point():
	points += 1
	label.text = "points " + str(points)

func apple_collected():
	apples_left -= 1

	if apples_left <= 0:
		get_tree().change_scene_to_file("res://WIN.tscn")
		


func _lose():
	get_tree().change_scene_to_file("res://LOSE.tscn")
