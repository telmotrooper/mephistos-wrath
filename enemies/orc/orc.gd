extends CharacterBody3D

func _ready() -> void:
	$warrok/AnimationPlayer.play("Bouncing Fight Idle")
	
	var mesh_instances = $warrok/Armature/Skeleton3D.get_children() as Array[MeshInstance3D]
	
	# Copy materials to make them unique between instances.
	for mesh_instance in mesh_instances:
		var material = mesh_instance.get_active_material(0).duplicate()
		mesh_instance.set_surface_override_material(0, material)

func highlight() -> void:
	$Label3D.show()
	var mesh_instances = $warrok/Armature/Skeleton3D.get_children() as Array[MeshInstance3D]
	for mesh_instance in mesh_instances:
		mesh_instance.get_active_material(0).next_pass = load("res://shaders/highlight.material")

func lowlight() -> void:
	$Label3D.hide()
	var mesh_instances = $warrok/Armature/Skeleton3D.get_children() as Array[MeshInstance3D]
	for mesh_instance in mesh_instances:
		mesh_instance.get_active_material(0).next_pass = null
