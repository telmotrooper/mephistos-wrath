extends Control

func _on_top_menu_button_pressed(unique_node_name: String) -> void:
	var node = get_node(unique_node_name)
	if node.visible:
		node.hide()
	else:
		node.show()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("character_window"):
		_on_top_menu_button_pressed("%ChiaracterWindow")
	elif Input.is_action_just_pressed("abilities_window"):
		_on_top_menu_button_pressed("%AbilitiesWindow")
	elif Input.is_action_just_pressed("inventory_window"):
		_on_top_menu_button_pressed("%InventoryWindow")
	elif Input.is_action_just_pressed("quest_log_window"):
		_on_top_menu_button_pressed("%QuestLogWindow")
	elif Input.is_action_just_pressed("map_window"):
		_on_top_menu_button_pressed("%MapWindow")
