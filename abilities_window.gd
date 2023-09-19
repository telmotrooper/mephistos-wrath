extends Window

func _physics_process(_delta: float) -> void:
	title = "Abilities (" + GameState.active_character.name + ")"
