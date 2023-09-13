extends Control

var border : CompressedTexture2D = load("res://icons/player-circle-border.svg")
var border_selected : CompressedTexture2D = load("res://icons/player-circle-border-selected.svg")

@export var character: Character

func _ready() -> void:
	tooltip_text = "%s\nHP: %d/%d\nMP: %d/%d" % [
		character.name, character.hp, character.max_hp, character.mp, character.max_mp
	]
	$HP.value = float(character.hp) / character.max_hp * 50
	$MP.value = float(character.mp) / character.max_mp * 50

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		GameState.selected_characters = [self]
		get_tree().call_group("character_portraits", "_on_portrait_selected")

func _on_portrait_selected() -> void:
	if GameState.selected_characters[0] == self:
		$Border.texture = border_selected
	else:
		$Border.texture = border
