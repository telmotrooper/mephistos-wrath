extends Control

var dragging := false
var selected = []
var drag_start := Vector2.ZERO
var select_rect := RectangleShape2D.new()

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

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if len(selected) == 0:
				dragging = true
				drag_start = event.position
		elif dragging:
			dragging = false
			queue_redraw()
	if event is InputEventMouseMotion and dragging:
		queue_redraw()

func _draw() -> void:
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color.YELLOW, false, 1.0)
