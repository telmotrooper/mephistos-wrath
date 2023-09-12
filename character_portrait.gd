@tool
extends Control

@export var character: Character

@export_range(0, 50) var health_points = 50 : set = _set_health, get = _get_health
@export_range(0, 50) var mana_points = 50 : set = _set_mana, get = _get_mana

@onready var hp = $HP
@onready var mp = $MP

func _ready() -> void:
	tooltip_text = "%s\nHP: %d/%d\nMP: %d/%d" % [
		character.name, character.hp, character.max_hp, character.mp, character.max_mp
	]

func _set_health(val):
	if not is_inside_tree():
		await ready
	hp.value = val

func _get_health():
	if not hp:
		return 50
	return hp.value

func _set_mana(val):
	if not is_inside_tree():
		await ready
	mp.value = val

func _get_mana():
	if not mp:
		return 50
	else:
		return mp.value
