extends Node3D

@export var character: Character

func _ready() -> void:
	$knight/AnimationPlayer.play("Combat Idle")

func set_selected(value) -> void:
	$Decal.visible = value

func _on_character_selected() -> void:
	set_selected(GameState.selected_characters[0].character == character)
