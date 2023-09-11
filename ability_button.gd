extends TextureProgressBar

@export var key: StringName
@export var label: String
@export var cooldown_time: float = 1.0

var spinning := false

func _ready():
	$Label.text = label

func _physics_process(_delta):
	if Input.is_action_just_pressed(key) and not spinning:
		spinning = true
		print("pressed ", self.name)
		
		value = 0
		var tween = create_tween()
		tween.tween_property(self, "value", 100, cooldown_time)
		tween.tween_callback(func(): spinning = false)
