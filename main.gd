extends Node3D

var scenes:Dictionary[String,PackedScene]
var rolled_dices:Array[RigidBody3D]
var dice_events_script:GDScript = preload("res://assets/dice_events.gd")
var dice_roll_total:int=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(dice_events_script)
	#A better implementation
	for diceButton in $RightMenu/DiceButtons.get_children():
		diceButton.pressed.connect(_on_roll_button_pressed.bind(diceButton))
	
	get_node("RightMenu/Clear Button").pressed.connect(_clear_all_dice)
	scenes = {
		"d4": load("res://assets/d_4.tscn"),
		"d6": load("res://assets/d_6.tscn"),
		"d8": load("res://assets/d_8.tscn"),
		"d10": load("res://assets/d_10.tscn"),
		"d12": load("res://assets/d_12.tscn"),
		"d20": load("res://assets/d_20.tscn"),
	}
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_roll_button_pressed(button:TextureButton) -> void:
	if button.has_meta("dice_to_roll"):
		var buttonNameToRoll = button.get_meta("dice_to_roll")
		_roll_dice(buttonNameToRoll)
	else:
		print("Button",button," has no metadata")
	#print("Will roll:", buttonNameToRoll)
	pass
func _dice_finished_rolling(result:int,dt:String):
	# Set the total to zero first and then summ all dice results
	dice_roll_total=0
	for dice_index in rolled_dices.size():
		var rolled_dice = rolled_dices[dice_index]
		if rolled_dice.has_meta(GlobalUtils.META_KEY_ROLL_RESULT):
			var roll_result=rolled_dice.get_meta(GlobalUtils.META_KEY_ROLL_RESULT)
			dice_roll_total = dice_roll_total + roll_result
			$"Roll Result".text="[wave amp=20.0 freq=5.0][rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0] 🎲 "+str(dice_roll_total)+" [/rainbow][/wave]"
			print("Dice finished rolling and the result is : ", result, "\nDice type is: ", dt)

func _roll_dice(dice_name:String):
	var spawn_point:Node3D=get_node("dice_throwing_point")
	var spawn_point_position = spawn_point.global_position
	var dice:RigidBody3D=scenes[dice_name].instantiate()
	rolled_dices.append(dice)
	dice.set_script(dice_events_script)
	dice._finished_rolling.connect(_dice_finished_rolling)
	add_child(dice)
	dice.global_position=spawn_point_position

func _clear_all_dice():
	for dice_index in rolled_dices.size():
		var dice_to_remove_from_the_scene:RigidBody3D = rolled_dices[dice_index]
		#Remove from the scene
		dice_to_remove_from_the_scene.queue_free()
		print(dice_index)
	# Clear the array
	rolled_dices.clear()
