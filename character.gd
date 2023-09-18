extends Node3D

@export var character: Character

func _ready() -> void:
	$knight/AnimationPlayer.play("Combat Idle")

func set_selected(value) -> void:
	$Decal.visible = value

func _on_character_selected() -> void:
	set_selected(GameState.selected_characters[0].character == character)

func _on_character_body_3d_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		print("%s clicked" % character.name)
