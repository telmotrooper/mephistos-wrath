extends Control

var action_to_node = {
	"character_window": "%CharacterWindow",
	"abilities_window": "%AbilitiesWindow",
	"inventory_window": "%InventoryWindow",
	"quest_log_window": "%QuestLogWindow",
	"map_window": "%MapWindow"
}

func _on_top_menu_button_pressed(unique_node_name: String) -> void:
	var node = get_node(unique_node_name)
	if node.visible:
		node.hide()
	else:
		node.show()

func _physics_process(_delta: float) -> void:
	for action in action_to_node:
		if Input.is_action_just_pressed(action):
			_on_top_menu_button_pressed(action_to_node[action])
