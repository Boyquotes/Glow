extends Popup

onready var buttonContainer = get_node("Panel/VBoxContainer")
onready var keybindButtonScript = load("res://Menus/KeybindButton.gd")

var defaultKeybinds = {
	"pause": 80,
	"jump": 87,
	"left": 65,
	"right": 68,
	"cancel": 16777217,
	"glow": 32
}

var buttons = {}

var keybinds

func _ready():
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = key
		var button_value = keybinds[key]
		button.text = OS.get_scancode_string(button_value)
		
		button.set_script(keybindButtonScript)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		
		hbox.add_child(label)
		hbox.add_child(button)
		buttonContainer.add_child(hbox)
		
		buttons[key] = button

func _on_SaveButton_pressed():
	Global.keybinds = keybinds.duplicate()
	Global.set_game_binds()
	Global.write_game_binds()
	self.visible = false

func _on_ResetButton_pressed():
	keybinds = defaultKeybinds.duplicate()

	for k in keybinds.keys():
		buttons[k].text = OS.get_scancode_string(keybinds[k])

	Global.keybinds = keybinds.duplicate()
	Global.set_game_binds()
	Global.write_game_binds()

func _on_CancelButton_pressed():
	self.visible = false
	
func change_keybind(key, value):
	print(value)
	keybinds[key] = value
	
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			buttons[key].text = "Unassigned"
