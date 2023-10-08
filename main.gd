extends Node3D

@export var initial_scene: PackedScene

var current_scene = null
var loading_scene = null
var progress = []

func _ready() -> void:
	set_process(false)
	load_scene(initial_scene.get_path())

func load_scene(scene_to_load: NodePath) -> void:
	loading_scene = scene_to_load
	ResourceLoader.load_threaded_request(loading_scene, "", true)
	$FadeTransition.fade_out()
	await $FadeTransition.faded_out
	
	if current_scene:
		$World.remove_child(current_scene)
		if is_instance_valid(current_scene):
			current_scene.queue_free()
		current_scene = null
	set_process(true)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(loading_scene, progress)
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(loading_scene)
		loading_scene = null
		current_scene = new_scene.instantiate()
		$World.add_child(current_scene)
		$FadeTransition.fade_in()
		set_process(false)
