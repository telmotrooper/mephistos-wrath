extends Node3D

func _ready() -> void:
	$knight/AnimationPlayer.get_animation("Combat Idle").loop = true
	$knight/AnimationPlayer.play("Combat Idle")
