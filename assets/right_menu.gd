extends Node
signal _dice_throw_button_pressed(dice_name:String)
signal _clear_dices()
var dice_button_names: Array[String] = ["d4", "d6", "d8", "d10", "d12", "d20"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dice_buttons = get_children()
	
	# Bind button pressed event listener to all buttons
	for button_index in dice_buttons.size():
		var button = dice_buttons[button_index]
		if dice_button_names.has(button.name):
			button.pressed.connect(func(): _dice_throw_button_pressed.emit(button.name))
		elif button.name == "Clear Button":
			button.pressed.connect(func(): _clear_dices.emit())
		else:
			button.pressed.connect(func(): print("An unexpected button is clicked"))
	pass # Replace with function body.
