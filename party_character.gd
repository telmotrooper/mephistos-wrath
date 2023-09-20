extends Node3D

@export var character: Character

var mouse_sensitivity := 0.5
var horizontal := 0.0
var vertical := 0.0
var h_acceleration := 10.0
var v_acceleration := 10.0

func _ready() -> void:
	$Label3D.text = character.name
	$knight/AnimationPlayer.play("Combat Idle")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		horizontal -= event.relative.x * mouse_sensitivity
		vertical += event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	%HorizontalPivot.rotation_degrees.y = lerp(%HorizontalPivot.rotation_degrees.y, horizontal, delta * h_acceleration)
	%VerticalPivot.rotation_degrees.x = lerp(%VerticalPivot.rotation_degrees.x, vertical, delta * v_acceleration)


func set_selected(value) -> void:
	$Decal.visible = value

func _on_character_selected() -> void:
	print("_on_character_selected")
	set_selected(GameState.selected_characters.has(character))
	if (GameState.active_character == character):
		grab_camera()

func _on_character_body_3d_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		GameState.select_characters(character, [character])

func _on_character_body_3d_mouse_entered() -> void:
	$Label3D.show()

func _on_character_body_3d_mouse_exited() -> void:
	$Label3D.hide()

func grab_camera() -> void:
	%Camera3D.make_current()

