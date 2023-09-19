extends Window

func _physics_process(_delta: float) -> void:
	title = "Character (" + GameState.active_character.name + ")"
