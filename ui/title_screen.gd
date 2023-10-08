extends Node

@export var new_game_scene: PackedScene

func _ready() -> void:
	$Node3D/mage/AnimationPlayer.play("Combat Idle")

func _on_new_game_button_pressed() -> void:
	$"/root/Main".load_scene(new_game_scene.get_path())

func _on_exit_button_pressed() -> void:
	get_tree().quit()
