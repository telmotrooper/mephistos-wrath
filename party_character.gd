extends CharacterBody3D

@export var character: Character

# Character
var character_speed := 8.0
var fall_acceleration := 75.0

# State
var navigating := false

var model: Node3D
var animation_player: AnimationPlayer
var skeleton_3d: Skeleton3D

func _ready() -> void:
	$Label3D.text = character.name
	
	$Model.queue_free()
	model = character.model.instantiate()
	add_child(model)
	
	animation_player = model.find_child("AnimationPlayer")
	animation_player.play("Combat Idle")
	
	skeleton_3d = model.find_child("Skeleton3D")
	var mesh_instances = skeleton_3d.get_children() as Array[MeshInstance3D]
	
	# Copy materials to make them unique between instances.
	for mesh_instance in mesh_instances:
		var material = mesh_instance.get_active_material(0).duplicate()
		mesh_instance.set_surface_override_material(0, material)

func _physics_process(_delta: float) -> void:
	var direction_from_wasd = Vector3.ZERO
	if GameState.active_character == character:
		if not Input.is_action_pressed("ctrl"): # Ctrl is used for hotkeys, ignore WASD when it's pressed.
			direction_from_wasd = Vector3(
				Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
				0,
				Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))

	if navigating:
		if $NavigationAgent3D.is_navigation_finished() or direction_from_wasd != Vector3.ZERO:
			navigating = false
			if is_instance_valid($CameraPivot.nav_indicator):
				$CameraPivot.nav_indicator.queue_free()
		var target_position = $NavigationAgent3D.get_next_path_position()
		var direction = global_position.direction_to(target_position)	
		if animation_player.current_animation != "Combat Running":
			animation_player.play("Combat Running")
		model.look_at(position - direction, Vector3.UP)
		velocity = direction * character_speed
	
	elif direction_from_wasd != Vector3.ZERO:
		var direction = direction_from_wasd

		var horizontal_rotation = %HorizontalPivot.global_transform.basis.get_euler().y
		direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()

		if GameState.active_character == character and direction != Vector3.ZERO:
			if animation_player.current_animation != "Combat Running":
				animation_player.play("Combat Running")
			model.look_at(position + direction, Vector3.UP)
			velocity.x = -direction.x * character_speed
			velocity.z = -direction.z * character_speed
	
	else:
		velocity = Vector3.ZERO
		if animation_player.current_animation != "Combat Idle":
				animation_player.play("Combat Idle")

#	velocity.y -= fall_acceleration * delta # Gravity
	move_and_slide()

func set_selected(value) -> void:
	$Decal.visible = value

func _on_character_selected() -> void:
	set_selected(GameState.selected_characters.has(character))
	if GameState.active_character == character and get_viewport().get_camera_3d() != %Camera3D:
		$CameraPivot.grab_camera()

func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		GameState.select_characters(character, [character])

func highlight() -> void:
	$Label3D.show()
	var mesh_instances = skeleton_3d.get_children() as Array[MeshInstance3D]
	for mesh_instance in mesh_instances:
		mesh_instance.get_active_material(0).next_pass = load("res://shaders/highlight.material")

func lowlight() -> void:
	$Label3D.hide()
	var mesh_instances = skeleton_3d.get_children() as Array[MeshInstance3D]
	for mesh_instance in mesh_instances:
		mesh_instance.get_active_material(0).next_pass = null
