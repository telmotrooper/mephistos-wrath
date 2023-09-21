extends CharacterBody3D

func _ready() -> void:
	$warrok/AnimationPlayer.play("Bouncing Fight Idle")

func _on_mouse_entered() -> void:
	$Label3D.show()

func _on_mouse_exited() -> void:
	$Label3D.hide()
