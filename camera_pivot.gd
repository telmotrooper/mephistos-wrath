extends Node3D

# Camera
var mouse_sensitivity := 0.5
var horizontal := 0.0
var vertical := 0.0
var h_acceleration := 10.0
var v_acceleration := 10.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		horizontal -= event.relative.x * mouse_sensitivity
		vertical += event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	vertical = clamp(vertical, -40, 50)
	%HorizontalPivot.rotation_degrees.y = lerp(%HorizontalPivot.rotation_degrees.y, horizontal, delta * h_acceleration)
	%VerticalPivot.rotation_degrees.x = lerp(%VerticalPivot.rotation_degrees.x, vertical, delta * v_acceleration)
