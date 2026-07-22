extends Node2D

var apples_left := 0

@onready var dialog: AcceptDialog = $AcceptDialog

func _ready() -> void:
	apples_left = get_tree().get_nodes_in_group("Area2D").size()


func apple_collected() -> void:
	apples_left -= 1

	if apples_left <= 0:
		get_tree().paused = true
		dialog.popup_centered()

func _on_accept_dialog_confirmed() -> void:
	get_tree().quit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
