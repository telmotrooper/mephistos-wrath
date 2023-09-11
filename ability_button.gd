extends TextureProgressBar

@export var key: StringName
@export var cooldown_time: float = 1.0
@export var image: CompressedTexture2D

var spinning := false
var clicked := false

func _ready():
	$Label.text = key
	texture_under = image
	texture_progress = image

func _physics_process(_delta):
	var pressed = Input.is_action_just_pressed("hotkey_" + key) if key else false
	
	if image:
		if not spinning and (pressed or clicked):
			spinning = true
			print("pressed ", self.name)
			
			value = 0
			var tween = create_tween()
			tween.tween_property(self, "value", 100, cooldown_time)
			tween.tween_callback(func(): spinning = false)
		clicked = false

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked = true
