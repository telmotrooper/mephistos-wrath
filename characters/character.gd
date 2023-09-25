extends Resource
class_name Character

@export var name: StringName = "Character Name"
@export var picture : CompressedTexture2D
@export var model : PackedScene

@export var max_hp: int
@export var hp: int

@export var max_mp: int
@export var mp: int

@export var character_class: Class
@export var ability_bar : Array[Ability] = []
