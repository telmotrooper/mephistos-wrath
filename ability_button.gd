extends TextureProgressBar

@export var key: StringName
@export var label: String

func _ready():
	$Label.text = label

func _physics_process(_delta):
	if Input.is_action_just_pressed(key) and not $AnimationPlayer.is_playing():
		print("pressed ", self.name)
		$AnimationPlayer.play("rotate")
