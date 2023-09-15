extends Window

func _physics_process(_delta: float) -> void:
	title = "Character (" + GameState.selected_characters[0].character.name + ")"
