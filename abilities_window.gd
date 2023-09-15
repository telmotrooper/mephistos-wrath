extends Window

func _physics_process(_delta: float) -> void:
	title = "Abilities (" + GameState.selected_characters[0].character.name + ")"

func _on_close_requested() -> void:
	hide()
