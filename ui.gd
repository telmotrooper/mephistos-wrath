extends Control

func _on_abilities_button_pressed() -> void:
	if $AbilitiesWindow.visible:
		$AbilitiesWindow.hide()
	else:
		$AbilitiesWindow.show()
