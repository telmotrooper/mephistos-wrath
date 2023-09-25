extends Node3D

var mouse_sensitivity := 0.5
var horizontal := 0.0
var vertical := 0.0
var h_acceleration := 10.0
var v_acceleration := 10.0
var cam_acceleration := 10.0

const ZOOM_STEP := 0.5
var min_zoom := 2
var max_zoom := 5
var zoom: float

var nav_indicator: Node3D

func _ready() -> void:
	zoom = %SpringArm3D.spring_length

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		horizontal -= event.relative.x * mouse_sensitivity
		vertical += event.relative.y * mouse_sensitivity
	elif event.is_action_pressed("zoom_in"):
		if get_viewport().get_camera_3d() == %TacticalCamera:
			%Camera3D.make_current()
		elif zoom > min_zoom:
			zoom -= ZOOM_STEP
	elif event.is_action_pressed("zoom_out"):
		if zoom < max_zoom:
			zoom += ZOOM_STEP
		else:
			%TacticalCamera.make_current()
	if GameState.active_character == $"..".character and Input.is_action_just_released("right_mouse_button") and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		navigate()

func _physics_process(delta: float) -> void:
	vertical = clamp(vertical, -40, 50)
	%HorizontalPivot.rotation_degrees.y = lerp(%HorizontalPivot.rotation_degrees.y, horizontal, delta * h_acceleration)
	%VerticalPivot.rotation_degrees.x = lerp(%VerticalPivot.rotation_degrees.x, vertical, delta * v_acceleration)
	%SpringArm3D.spring_length = lerp(%SpringArm3D.spring_length, zoom, delta * cam_acceleration)

func grab_camera() -> void:
	var existing_camera = get_viewport().get_camera_3d()
	GameState.transition_camera.global_transform.origin = existing_camera.global_transform.origin
	GameState.transition_camera.global_rotation_degrees = existing_camera.global_rotation_degrees
	GameState.transition_camera.make_current()

	var tween = create_tween()
	tween.tween_property(GameState.transition_camera, "global_transform:origin", %Camera3D.global_transform.origin, 0.25)
	tween.tween_callback(func(): %Camera3D.make_current())

func navigate() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = %Camera3D.project_ray_origin(mouse_position)
	var to = from + %Camera3D.project_ray_normal(mouse_position) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.set_collision_mask(0b010) # Only collide with layer 2 (floor).
	ray_query.from = from
	ray_query.to = to
	var result = space.intersect_ray(ray_query)
	if len(result):
		if is_instance_valid(nav_indicator):
			nav_indicator.queue_free()
		%NavigationAgent3D.set_target_position(result.position)
		nav_indicator = load("res://navigation_indicator.tscn").instantiate()
		get_parent().add_child(nav_indicator)
		nav_indicator.global_transform.origin = result.position
		$"..".navigating = true
