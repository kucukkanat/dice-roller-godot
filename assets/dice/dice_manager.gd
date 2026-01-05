extends Node
#signal _dice_throw_button_pressed(dice_name:String)
#signal _clear_dices()
var dices_on_the_board:Array[Dice]=[]
@export var screen:RichTextLabel
var dice_scenes: Dictionary[String,PackedScene] = {
	"d4": preload("res://assets/dice/d_4.tscn"),
	"d6": preload("res://assets/dice/d_6.tscn"),
	"d8": preload("res://assets/dice/d_8.tscn"),
	"d10": preload("res://assets/dice/d_10.tscn"),
	"d12": preload("res://assets/dice/d_12.tscn"),
	"d20": preload("res://assets/dice/d_20.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _roll_dice(_name:String):
	print("Rolling dice:", _name)
	var dice:Dice = dice_scenes[_name].instantiate()
	dices_on_the_board.append(dice)
	print(dice.has_signal("_roll_state_changed"))
	dice._roll_state_changed.connect(_recalculate_sum)
	add_child(dice)
	pass

func _recalculate_sum():
	var sum=0
	for dice in dices_on_the_board:
		sum = sum + dice.roll_result
	if screen:
		screen.text = "Dice roll result=" + str(sum)
	else:
		print("I have calculated the sum but there is no screen assigned, so it will not be visible on the screen")
	pass

func _clear_all_dices():
	for dice in dices_on_the_board:
		dice.queue_free()
	dices_on_the_board.clear()
