extends RigidBody3D
signal _finished_rolling(result:int, dice_type:String)

func _ready() -> void:
	# Connect sleeping signal
	# This catches the sleeping_state_changed signal of the node it is connected to
	# so it should be connecting to a RigidBody3D in our case!
	sleeping_state_changed.connect(_on_sleeping_state_changed)

func _on_sleeping_state_changed():
	if sleeping:
		var highest_node := _get_highest_child_by_y()
		if highest_node:
			var face_value := _parse_face_value_from_name(highest_node.name)
			if face_value >= 0:
				print("Sleeping - top face value:", face_value)
				set_meta(GlobalUtils.META_KEY_ROLL_RESULT, face_value)
				_finished_rolling.emit(face_value,get_name())
			else:
				print("Sleeping - highest child:", highest_node.name, "y=", highest_node.global_transform.origin.y)
		else:
			print("Sleeping - no child Node3D found")
	else:
		print("Not Sleeping")


func _parse_face_value_from_name(name: String) -> int:
	# Expected format: d<dice_face_number>_<face_value>, e.g. d4_1
	var parts := name.split("_")
	if parts.size() < 2:
		return -1
	var face_str := parts[1]
	# Try direct integer parse; to_int() returns 0 on failure so check
	var val := face_str.to_int()
	if val == 0 and face_str != "0":
		return -1
	return val

func _get_highest_child_by_y() -> Node:
	var highest_node: Node = null
	var highest_y := -INF
	var stack := [self]
	while stack.size() > 0:
		var node = stack.pop_back()
		for child in node.get_children():
			stack.append(child)
			if child is Node3D:
				var y = child.global_transform.origin.y
				if y > highest_y:
					highest_y = y
					highest_node = child
	return highest_node
