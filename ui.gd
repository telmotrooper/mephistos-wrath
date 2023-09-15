extends Control

func _on_top_menu_button_pressed(unique_node_name: String) -> void:
	var node = get_node(unique_node_name)
	if node.visible:
		node.hide()
	else:
		node.show()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("character_window"):
		%CharacterWindow.show()
	elif Input.is_action_just_pressed("abilities_window"):
		%AbilitiesWindow.show()
	elif Input.is_action_just_pressed("inventory_window"):
		%InventoryWindow.show()
	elif Input.is_action_just_pressed("quest_log_window"):
		%QuestLogWindow.show()
	elif Input.is_action_just_pressed("map_window"):
		%MapWindow.show()
