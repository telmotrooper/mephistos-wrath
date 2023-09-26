extends Node

var ability_bar_size := 14
var ability_bar_locked := false

var selected_characters: Array[Character] = []
var active_character: Character

@onready var transition_camera := $TransitionCamera
var camera_mode := "CharacterCamera" # "CharacterCamera" or "TacticalCamera"

func select_characters(active, selected) -> void:
	if active != null:
		GameState.active_character = active
	GameState.selected_characters.clear()
	GameState.selected_characters.assign(selected)
	get_tree().call_group("character_portraits", "_on_portrait_selected")
	get_tree().call_group("party_characters", "_on_character_selected")
