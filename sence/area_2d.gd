extends Area2D


func _on_hitbox_body_entered(body):
	if body.name == "CharacterBody2D": # تأكد أن هذا اسم عقدة اللاعب لديك
		queue_free() # حذف العدو من المشهد


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
