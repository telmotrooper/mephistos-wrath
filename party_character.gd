extends CharacterBody3D

@export var character: Character

# Camera
var mouse_sensitivity := 0.5
var horizontal := 0.0
var vertical := 0.0
var h_acceleration := 10.0
var v_acceleration := 10.0

# Character
var character_speed := 8.0
var fall_acceleration := 75.0

# State
var navigating := false
var nav_indicator: Node3D

func _ready() -> void:
	$Label3D.text = character.name
	$knight/AnimationPlayer.play("Combat Idle")
	
	var mesh_instances = $knight/Armature/Skeleton3D.get_children() as Array[MeshInstance3D]
	
	# Copy materials to make them unique between instances.
	for mesh_instance in mesh_instances:
		var material = mesh_instance.get_active_material(0).duplicate()
		mesh_instance.set_surface_override_material(0, material)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		horizontal -= event.relative.x * mouse_sensitivity
		vertical += event.relative.y * mouse_sensitivity
	
	if GameState.active_character == character and Input.is_action_just_pressed("left_mouse_button"):
		var mouse_position = get_viewport().get_mouse_position()
		var ray_length = 100
		var from = %Camera3D.project_ray_origin(mouse_position)
		var to = from + %Camera3D.project_ray_normal(mouse_position) * ray_length
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		var result = space.intersect_ray(ray_query)
		if len(result):
			if is_instance_valid(nav_indicator):
				nav_indicator.queue_free()
			$NavigationAgent3D.set_target_position(result.position)
			nav_indicator = load("res://navigation_indicator.tscn").instantiate()
			get_parent().add_child(nav_indicator)
			nav_indicator.global_transform.origin = result.position
			navigating = true

func _physics_process(delta: float) -> void:
	vertical = clamp(vertical, -40, 50)
	%HorizontalPivot.rotation_degrees.y = lerp(%HorizontalPivot.rotation_degrees.y, horizontal, delta * h_acceleration)
	%VerticalPivot.rotation_degrees.x = lerp(%VerticalPivot.rotation_degrees.x, vertical, delta * v_acceleration)

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
			if is_instance_valid(nav_indicator):
				nav_indicator.queue_free()
		var target_position = $NavigationAgent3D.get_next_path_position()
		var direction = global_position.direction_to(target_position)	
		if $knight/AnimationPlayer.current_animation != "Combat Running":
			$knight/AnimationPlayer.play("Combat Running")
		$knight.look_at(position - direction, Vector3.UP)
		velocity = direction * character_speed
	
	elif direction_from_wasd != Vector3.ZERO:
		var direction = direction_from_wasd

		var horizontal_rotation = %HorizontalPivot.global_transform.basis.get_euler().y
		direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()

		if GameState.active_character == character and direction != Vector3.ZERO:
			if $knight/AnimationPlayer.current_animation != "Combat Running":
				$knight/AnimationPlayer.play("Combat Running")
			$knight.look_at(position + direction, Vector3.UP)
			velocity.x = -direction.x * character_speed
			velocity.z = -direction.z * character_speed
	
	else:
		velocity = Vector3.ZERO
		if $knight/AnimationPlayer.current_animation != "Combat Idle":
				$knight/AnimationPlayer.play("Combat Idle")

#	velocity.y -= fall_acceleration * delta # Gravity
	move_and_slide()

func set_selected(value) -> void:
	$Decal.visible = value

func _on_character_selected() -> void:
	set_selected(GameState.selected_characters.has(character))
	if GameState.active_character == character and get_viewport().get_camera_3d() != %Camera3D:
		grab_camera()

func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		GameState.select_characters(character, [character])

func grab_camera() -> void:
	var existing_camera_position = get_viewport().get_camera_3d().global_transform.origin
	var camera_position = %Camera3D.global_transform.origin
	%Camera3D.global_transform.origin = existing_camera_position
	%Camera3D.make_current()
	var tween = create_tween()
	tween.tween_property(%Camera3D, "global_transform:origin", camera_position, 0.25)

func highlight() -> void:
	$Label3D.show()
	var mesh_instances = $knight/Armature/Skeleton3D.get_children() as Array[MeshInstance3D]
	for mesh_instance in mesh_instances:
		mesh_instance.get_active_material(0).next_pass = load("res://shaders/highlight.material")

func lowlight() -> void:
	$Label3D.hide()
	var mesh_instances = $knight/Armature/Skeleton3D.get_children() as Array[MeshInstance3D]
	for mesh_instance in mesh_instances:
		mesh_instance.get_active_material(0).next_pass = null
