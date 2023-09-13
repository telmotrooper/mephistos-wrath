@tool
extends Control

@export var character: Character

func _ready() -> void:
	tooltip_text = "%s\nHP: %d/%d\nMP: %d/%d" % [
		character.name, character.hp, character.max_hp, character.mp, character.max_mp
	]
	$HP.value = float(character.hp) / character.max_hp * 50
	$MP.value = float(character.mp) / character.max_mp * 50
