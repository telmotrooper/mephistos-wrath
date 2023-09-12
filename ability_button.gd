extends TextureProgressBar

@export var key: StringName
@export var ability: Ability

var spinning := false
var clicked := false

func _ready() -> void:
	$Label.text = key
	texture_under = ability.image
	texture_progress = ability.image
	if ability.name or ability.description:
		tooltip_text = ability.name + "\n" + ability.description

func _physics_process(_delta: float) -> void:
	var pressed = Input.is_action_just_pressed("hotkey_" + key) if key else false

	if not spinning and (pressed or clicked):
		get_tree().call_group("ability_buttons", "_on_ability_triggered", ability.name)
		spin()
	clicked = false

func spin() -> void:
	spinning = true
	print("pressed ", self.name)
	
	value = 0
	var tween = create_tween()
	tween.tween_property(self, "value", 100, ability.cooldown_time)
	tween.tween_callback(func(): spinning = false)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		clicked = true

func _on_ability_triggered(ability_name: StringName) -> void:
	if ability_name == ability.name:
		spin()

func _get_drag_data(_at_position: Vector2) -> Variant:
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data.ability.name != ""

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	self.ability = data.ability
	_ready()
	data.ability = load("res://abilities/empty.tres")
	data._ready()
