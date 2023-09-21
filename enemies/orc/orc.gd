extends CharacterBody3D

func _ready() -> void:
	$warrok/AnimationPlayer.play("Bouncing Fight Idle")

func highlight() -> void:
	$Label3D.show()

func lowlight() -> void:
	$Label3D.hide()
