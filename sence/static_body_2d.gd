extends StaticBody2D




func _on_child_entered_tree(node: Node) -> void:
	get_tree().reload_current_scene()
