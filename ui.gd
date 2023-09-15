extends Control

func _on_top_menu_button_pressed(unique_node_name: String) -> void:
	var node = get_node(unique_node_name)
	if node.visible:
		node.hide()
	else:
		node.show()
