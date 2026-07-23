extends Area2D
@onready var game_manger: Node = %gamemanger
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		game_manger.apple_collected()
		game_manger.add_point()
		queue_free()
