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

func _ready() -> void:
	zoom = %SpringArm3D.spring_length

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		horizontal -= event.relative.x * mouse_sensitivity
		vertical += event.relative.y * mouse_sensitivity
	elif event.is_action_pressed("zoom_in") and zoom > min_zoom:
		zoom -= ZOOM_STEP
	elif event.is_action_pressed("zoom_out") and zoom < max_zoom:
		zoom += ZOOM_STEP

func _physics_process(delta: float) -> void:
	vertical = clamp(vertical, -40, 50)
	%HorizontalPivot.rotation_degrees.y = lerp(%HorizontalPivot.rotation_degrees.y, horizontal, delta * h_acceleration)
	%VerticalPivot.rotation_degrees.x = lerp(%VerticalPivot.rotation_degrees.x, vertical, delta * v_acceleration)
	%SpringArm3D.spring_length = lerp(%SpringArm3D.spring_length, zoom, delta * cam_acceleration)
