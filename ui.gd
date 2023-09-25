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

var select_all := false
var stop := false
var last_mouse_position: Vector2
var able_to_grab_mouse := false

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
	if Input.is_action_just_pressed("select_all"):
		var party_characters = get_tree().get_nodes_in_group("party_characters")
		selected = party_characters.map(func(node): return node.character)
		GameState.select_characters(null, selected)
	if Input.is_action_just_pressed("highlight"):
		get_tree().call_group("highlightable", "highlight")
	if Input.is_action_just_released("highlight"):
		get_tree().call_group("highlightable", "lowlight")
	if Input.is_action_just_pressed("pause"):
		pause()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and able_to_grab_mouse and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		var mouse_distance = last_mouse_position.distance_squared_to(get_viewport().get_mouse_position())
		if mouse_distance > 1500:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			able_to_grab_mouse = true
			last_mouse_position = get_viewport().get_mouse_position()
		else:
			able_to_grab_mouse = false
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				get_viewport().warp_mouse(last_mouse_position)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_start = event.position
		elif dragging:
			dragging = false
			queue_redraw()
			if len(selected) > 0:
				GameState.select_characters(null, selected)
	if event is InputEventMouseMotion and dragging:
		queue_redraw()

func _draw() -> void:
	if dragging:
		var box := Rect2(drag_start, get_global_mouse_position() - drag_start)
		draw_rect(box, Color.YELLOW, false, 1.0)
		var party_characters = get_tree().get_nodes_in_group("party_characters")
		selected = party_characters.filter(
			func(node): return box.abs().has_point(get_viewport().get_camera_3d().unproject_position(node.transform.origin))
		).map(func(node): return node.character)

func _on_select_all_button_pressed() -> void:
	select_all = !select_all
	if select_all:
		%SelectAllButton.icon = load("res://icons/font_awesome/user-group.svg")
	else:
		%SelectAllButton.icon = load("res://icons/font_awesome/user-large-resized.svg")

func _on_stop_button_pressed() -> void:
	stop = !stop
	if stop:
		%StopButton.icon = load("res://icons/font_awesome/hand.svg")
	else:
		%StopButton.icon = load("res://icons/font_awesome/person-walking.svg")

func pause() -> void:
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		%PausedDialog.show()
	else:
		%PausedDialog.hide()
