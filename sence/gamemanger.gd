extends Node

@onready var label: Label = $"../CanvasLayer/Label"
@onready var dialog = $"../AcceptDialog"

var points = 0
var apples_left = 0

func _ready():
	apples_left = get_tree().get_nodes_in_group("apple").size()

func add_point():
	points += 1
	label.text = "points " + str(points)

func apple_collected():
	apples_left -= 1

	if apples_left <= 0:
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		get_tree().change_scene_to_file("res://WIN.tscn")
