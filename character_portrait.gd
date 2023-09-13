extends Control
class_name CharacterPortrait

var border : CompressedTexture2D = load("res://icons/player-circle-border.svg")
var border_selected : CompressedTexture2D = load("res://icons/player-circle-border-selected.svg")

var ability_bar_children : Array[Node]

@export var character: Character

func _ready() -> void:
	if len(GameState.selected_characters) == 0:
		GameState.selected_characters = [self]
		_on_portrait_selected()
	
	tooltip_text = "%s\nHP: %d/%d\nMP: %d/%d" % [
		character.name, character.hp, character.max_hp, character.mp, character.max_mp
	]
	$HP.value = float(character.hp) / character.max_hp * 50
	$MP.value = float(character.mp) / character.max_mp * 50

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		GameState.previously_selected_character = GameState.selected_characters[0]
		GameState.selected_characters = [self]
		
		get_tree().call_group("character_portraits", "_on_portrait_selected")

func _on_portrait_selected() -> void:
	if GameState.selected_characters[0] != self:
		$Border.texture = border
	elif GameState.previously_selected_character != self:
		$Border.texture = border_selected
		
		var lock_button: Node
		
		for child in %Abilities.get_children():
			%Abilities.remove_child(child)
			print(child.get_parent())
			if child.name == "LockButton":
				lock_button = child
			elif is_instance_valid(GameState.previously_selected_character) and child.parent_name == GameState.previously_selected_character.name:
				GameState.previously_selected_character.ability_bar_children.append(child)
			else:
				child.queue_free()
		
		var hotkeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

		while len(character.ability_bar) < GameState.ability_bar_size:
			var ability = load("res://abilities/empty.tres")
			character.ability_bar.append(ability)

		if len(ability_bar_children) > 0:
			for child in ability_bar_children:
				%Abilities.add_child(child)
		else:
			for ability in character.ability_bar:
				if ability == null:
					ability = load("res://abilities/empty.tres")
				
				var scene = load("res://ability_button.tscn")
				var ability_button = scene.instantiate()
				ability_button.parent_name = self.name
				ability_button.key = "" if len(hotkeys) == 0 else hotkeys.pop_front()
				ability_button.ability = ability
				%Abilities.add_child(ability_button)
		%Abilities.add_child(lock_button)
