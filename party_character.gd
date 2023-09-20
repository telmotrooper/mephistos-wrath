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

func _ready() -> void:
	$Label3D.text = character.name
	$knight/AnimationPlayer.play("Combat Idle")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		horizontal -= event.relative.x * mouse_sensitivity
		vertical += event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	vertical = clamp(vertical, -40, 50)
	%HorizontalPivot.rotation_degrees.y = lerp(%HorizontalPivot.rotation_degrees.y, horizontal, delta * h_acceleration)
	%VerticalPivot.rotation_degrees.x = lerp(%VerticalPivot.rotation_degrees.x, vertical, delta * v_acceleration)

	var direction = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))

	var horizontal_rotation = %HorizontalPivot.global_transform.basis.get_euler().y
	direction = direction.rotated(Vector3.UP, horizontal_rotation).normalized()
	
	if GameState.active_character == character and direction != Vector3.ZERO:
		$knight.look_at(position + direction, Vector3.UP)
		velocity.x = -direction.x * character_speed
		velocity.z = -direction.z * character_speed
	else:
		velocity = Vector3.ZERO
	
	move_and_slide()

func set_selected(value) -> void:
	$Decal.visible = value

func _on_character_selected() -> void:
	set_selected(GameState.selected_characters.has(character))
	if (GameState.active_character == character):
		grab_camera()

func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		GameState.select_characters(character, [character])

func _on_mouse_entered() -> void:
	$Label3D.show()

func _on_mouse_exited() -> void:
	$Label3D.hide()

func grab_camera() -> void:
	var existing_camera_position = get_viewport().get_camera_3d().global_transform.origin
	var camera_position = %Camera3D.global_transform.origin
	%Camera3D.global_transform.origin = existing_camera_position
	%Camera3D.make_current()
	var tween = create_tween()
	tween.tween_property(%Camera3D, "global_transform:origin", camera_position, 0.25)
