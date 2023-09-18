extends Window

func _physics_process(_delta: float) -> void:
	title = "Abilities (" + GameState.selected_characters[0].name + ")"
