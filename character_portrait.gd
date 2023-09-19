extends Control
class_name CharacterPortrait

var border : CompressedTexture2D = load("res://icons/player-circle-border.svg")
var border_selected : CompressedTexture2D = load("res://icons/player-circle-border-selected.svg")

@export var character: Character
@export var hotkey: StringName

func _ready() -> void:
	if len(GameState.selected_characters) == 0:
		GameState.selected_characters = [character]
		_on_portrait_selected()
		get_tree().call_group("party_characters", "_on_character_selected")
	
	tooltip_text = "%s (%s)\nHP: %d/%d\nMP: %d/%d" % [
		character.name, character.character_class.name, character.hp, character.max_hp, character.mp, character.max_mp
	]
	$Mask/Portrait.texture = character.picture
	$HP.value = float(character.hp) / character.max_hp * 50
	$MP.value = float(character.mp) / character.max_mp * 50

func _physics_process(_delta: float) -> void:
	var pressed = Input.is_action_just_pressed(hotkey) if hotkey else false
	if pressed:
		select_portrait()

func select_portrait() -> void:
	GameState.selected_characters = [character]
	get_tree().call_group("character_portraits", "_on_portrait_selected")
	get_tree().call_group("party_characters", "_on_character_selected")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		select_portrait()

func _on_portrait_selected() -> void:
	if not GameState.selected_characters.has(character):
		$Border.texture = border
	else:
		$Border.texture = border_selected
		
		var lock_button: Node
		
		for child in %Abilities.get_children():
			if child.name == "LockButton":
				lock_button = child
			elif child.parent_name != "":
				child.reparent(%HiddenAbilities)
			else:
				child.queue_free()
		
		var hotkeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

		var hidden_abilities = %HiddenAbilities.get_children().filter(
			func(node): return node.parent_name == self.name
		)

		while len(character.ability_bar) < GameState.ability_bar_size:
			var ability = load("res://abilities/empty.tres")
			character.ability_bar.append(ability)

		if len(hidden_abilities) > 0:
			for child in hidden_abilities:
				child.reparent(%Abilities)
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
		%Abilities.move_child(lock_button, -1)
