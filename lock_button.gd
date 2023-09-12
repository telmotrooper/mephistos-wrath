extends Button

var locked := false

func _ready() -> void:
	update_icon()

func _on_pressed() -> void:
	locked = not locked
	GameState.ability_bar_locked = locked
	update_icon()

func update_icon() -> void:
	icon = load("res://icons/font_awesome/lock.svg") if locked else load("res://icons/font_awesome/unlock.svg")
