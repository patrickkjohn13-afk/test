extends Area2D

@onready var gamemanger: Node = %gamemanger


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		gamemanger.halth()
		get_tree().reload_current_scene()
