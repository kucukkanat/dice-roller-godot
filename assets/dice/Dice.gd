extends RigidBody3D
class_name Dice
signal _roll_state_changed()
@export var roll_result:int
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sleeping_state_changed.connect(_on_sleeping_state_changed)
	# Add a random rotation to the dice
	rotate_x(PI* rng.randf_range(0,1))
	rotate_y(PI* rng.randf_range(0,1))
	rotate_z(PI* rng.randf_range(0,1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_sleeping_state_changed() -> void:
	if sleeping:
		var mesh:MeshInstance3D = get_node("mesh")
		#print(mesh)
		var faces:Array[Node]=mesh.get_children()
		var highest_y=-INF
		var highest_face:Node3D=null
		for face in faces:
			var face_height = face.global_position.y
			if face_height > highest_y:
				highest_y=face_height
				highest_face=face
				pass
		
		var parts = highest_face.name.split("_")
		var dice_type = parts[0]
		if dice_type == "d20":
			print("\nD20 faces:\n",faces,"\n")
		var result:int = int(parts[1])
		roll_result=result
		_roll_state_changed.emit()
		print(dice_type," rolled ", result)
	pass # Replace with function body.
