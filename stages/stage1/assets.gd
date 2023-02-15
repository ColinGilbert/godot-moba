tool

extends Spatial

export var prepare_for_baking = false setget toggle_prepare

func toggle_prepare(condition):
	if condition == true:
		for node in get_children():
			if node is MeshInstance:
				if node.mesh is ArrayMesh:
					node.mesh = node.mesh.duplicate()
					node.mesh.lightmap_unwrap(node.get_global_transform(), 0.05)
					node.use_in_baked_light = true
